package pl.aleokaz.backend.friends;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;

import pl.aleokaz.backend.friends.exceptions.FriendRequestNotFoundException;
import pl.aleokaz.backend.friends.exceptions.FriendshipNotFoundException;
import pl.aleokaz.backend.user.User;
import pl.aleokaz.backend.user.UserService;

@Service
public class FriendsService {

    @Autowired
    private UserService userService;

    @Autowired
    private FriendshipRepository friendshipRepository;

    @Autowired
    private FriendRequestRepository friendRequestRepository;

    @Autowired
    private KafkaTemplate<String, String> kafkaTemplate;

    public List<FriendRequest> getIncomingFriendRequests(UUID userId) {
        return friendRequestRepository.findAllByReceiverId(userId);
    }

    public List<FriendRequest> getSentFriendRequests(UUID userId) {
        return friendRequestRepository.findAllBySenderId(userId);
    }

    public FriendRequest sendFriendRequest(UUID senderId, UUID receiverId){
        if (senderId.equals(receiverId)) {
            throw new IllegalArgumentException("You cannot send a friend request to yourself.");
        }
        if (friendRequestRepository.existsBySenderIdAndReceiverId(senderId, receiverId)) {
            throw new IllegalArgumentException("Friend request already sent.");
        }
        if (friendshipRepository.existsByUserIdAndFriendId(senderId, receiverId)) {
            throw new IllegalArgumentException("Friendship already exists.");
        }

        User sender = userService.getUserById(senderId);
        User receiver = userService.getUserById(receiverId);

        FriendRequest friendRequest = new FriendRequest(sender, receiver);
        friendRequest = friendRequestRepository.save(friendRequest);
        kafkaTemplate.send(receiver.id().toString(), "New friend request from " + sender.username());
        return friendRequest;
    }

    public void cancelFriendRequest(UUID senderId, UUID receiverId) {
        List<FriendRequest> friendRequest = friendRequestRepository.findAllByReceiverIdAndSenderId(receiverId, senderId);
        if (friendRequest.isEmpty()) {
            throw new FriendRequestNotFoundException("receiver_id", receiverId.toString());
        }
        friendRequestRepository.delete(friendRequest.get(0));
    }

    public Friendship acceptFriendRequest(UUID senderId, UUID receiverId) {
        List<FriendRequest> friendRequest = friendRequestRepository.findAllByReceiverIdAndSenderId(receiverId, senderId);
        if (friendRequest.isEmpty()) {
            throw new FriendRequestNotFoundException("sender_id", senderId.toString());
        }
        FriendRequest request = friendRequest.get(0);
        User sender = request.sender();
        User receiver = request.receiver();
        Friendship friendship = new Friendship(sender, receiver);
        friendRequestRepository.delete(request);
        friendship = friendshipRepository.save(friendship);
        kafkaTemplate.send(sender.id().toString(), "Friend request accepted by " + receiver.username());
        return friendship;
    }

    public void denyFriendRequest(UUID senderId, UUID receiverId) {
        List<FriendRequest> friendRequest = friendRequestRepository.findAllByReceiverIdAndSenderId(receiverId, senderId);
        if (friendRequest.isEmpty()) {
            throw new FriendRequestNotFoundException("sender_id", senderId.toString());
        }
        FriendRequest request = friendRequest.get(0);
        friendRequestRepository.delete(request);
        kafkaTemplate.send(senderId.toString(), "Friend request denied by " + userService.getUserById(receiverId).username());
    }

    public List<User> getFriends(UUID currentUserId) {
        List<Friendship> friendships = friendshipRepository.findAllByUserId(currentUserId);
        return friendships.stream()
                .map(friendship -> friendship.getFriendId(currentUserId))
                .map(userService::getUserById)
                .toList();
    }

    public List<User> getFriendsOfUser(String username,UUID currentUserId) {
        //TODO: Privacy settings check
        User user = userService.getUserByUsername(username);
        return getFriends(user.id());
    }

    public void removeFriend(UUID currentUserId, UUID friendId){
        Optional<Friendship> friendship = friendshipRepository.findSymmetricalFriendship(currentUserId, friendId);
        if (friendship.isEmpty()) {
            throw new FriendshipNotFoundException("friend_id", friendId.toString());
        }
        friendshipRepository.delete(friendship.get());
        kafkaTemplate.send(friendId.toString(), "You have been removed from the friends list by " + userService.getUserById(currentUserId).username());
    }

    public static List<FriendDTO> usersAsFriendDtos(List<User> users) {
        return users.stream()
                .map(user -> FriendDTO.builder()
                        .username(user.username())
                        .avatar_url(user.profilePicture())
                        .build())
                .toList();
    }

    public static List<FriendDTO> friendRequestsAsFriendDtos(List<FriendRequest> friendRequests, UUID currentUserId) {
        return friendRequests.stream()
                .map(friendRequest -> friendRequest.toFriendDTO(currentUserId))
                .toList();
    }
}
