package pl.aleokaz.backend.friends;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import pl.aleokaz.backend.exceptions.UserNotFoundException;
import pl.aleokaz.backend.kafka.KafkaService;
import pl.aleokaz.backend.user.User;
import pl.aleokaz.backend.user.UserRepository;

@Service
public class FriendsService {

    public enum FriendStatus {
        SENT_FRIEND_REQUEST,
        ACCEPTED_FRIEND_REQUEST,
        TRIED_TO_ADD_YOURSELF,
        FRIENDSHIP_EXISTS,
        FRIENDSHIP_ALREADY_ACCEPTED,
        ALREADY_SENT_FRIEND_REQUEST,
        FRIEND_REMOVED,
        NO_FRIENDSHIP_TO_REMOVE,
    }

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private FriendshipRepository friendshipRepository;

    @Autowired
    private KafkaService kafkaService;
    
    public FriendStatus addFriend(FriendCommand addFriendCommand, UUID userId) throws UserNotFoundException {
        String friendUsername = addFriendCommand.username();
        User friend = userRepository.findByUsername(friendUsername);
        if(friend == null) throw new UserNotFoundException("username", friendUsername);
        User user = userRepository.getReferenceById(userId);
        if(user == null) throw new UserNotFoundException("id", userId.toString());
        if(user.id() == friend.id()) return FriendStatus.TRIED_TO_ADD_YOURSELF;

        Optional<Friendship> existingFriendship = friendshipRepository.findSymmetricalFriendship(user.id(), friend.id());
        if (existingFriendship.isEmpty()) {
            Friendship friendship = new Friendship(user, friend, false);
            friendshipRepository.save(friendship);
            kafkaService.sendMessage("notification", friend, "Friend request from " + user.username());
            return FriendStatus.SENT_FRIEND_REQUEST;
        }
        Friendship friendship = existingFriendship.get(); 
        if (friendship.friend().id() == userId){
            if(friendship.isActive()) return FriendStatus.FRIENDSHIP_ALREADY_ACCEPTED;
            friendship.isActive(true);
            friendshipRepository.save(friendship);
            kafkaService.sendMessage("notification", friend, "Friend request accepted by " + user.username());
            return FriendStatus.ACCEPTED_FRIEND_REQUEST;
        }
        return friendship.isActive() ? FriendStatus.FRIENDSHIP_EXISTS : FriendStatus.ALREADY_SENT_FRIEND_REQUEST;
    }

    public FriendStatus removeFriend(FriendCommand removeFriendCommand, UUID userId) throws UserNotFoundException {
        String friendUsername = removeFriendCommand.username();
        User friend = userRepository.findByUsername(friendUsername);
        if(friend == null) throw new UserNotFoundException("username", friendUsername);
        User user = userRepository.getReferenceById(userId);
        if(user == null) throw new UserNotFoundException("id", userId.toString());

        Optional<Friendship> existingFriendship = friendshipRepository.findSymmetricalFriendship(user.id(), friend.id());
        if (existingFriendship.isPresent()) {
            friendshipRepository.delete(existingFriendship.get());
            kafkaService.sendMessage("notification", friend, "Removed from friends by " + user.username());
            return FriendStatus.FRIEND_REMOVED;
        }
        return FriendStatus.NO_FRIENDSHIP_TO_REMOVE;
    }

    public List<FriendDTO> getFriends(UUID userId){
        List<Friendship> friendships = friendshipRepository.findAllByUserId(userId);
        List<FriendDTO> friendDTOs = friendships.stream()
            .map(friendship -> friendship.toFriendDTO(userId)).toList();
        return friendDTOs;
    }

    public List<FriendDTO> getFriendsOfUser(String username){
        User user = userRepository.findByUsername(username);
        if(user == null) return List.of();
        List<Friendship> friendships = friendshipRepository.findAllByUserId(user.id());
        List<FriendDTO> friendDTOs = friendships.stream()
            .filter(friendship -> friendship.isActive())
            .map(friendship -> friendship.toFriendDTO(user.id()))
            .toList();
        return friendDTOs;
    }
}