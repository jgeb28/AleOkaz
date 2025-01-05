package pl.aleokaz.backend.friends;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import pl.aleokaz.backend.user.User;
import pl.aleokaz.backend.user.UserRepository;

@Service
public class FriendsService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private FriendshipRepository friendshipRepository;
    
    public void addFriend(FriendCommand addFriendCommand, UUID userId){
        String firendUsername = addFriendCommand.username();
        User friend = userRepository.findByUsername(firendUsername);
        User user = userRepository.getReferenceById(userId);
        Optional<Friendship> existingFriendship = friendshipRepository.findSymmetricalFriendship(user.id(), friend.id());
        if (existingFriendship.isEmpty()) {
            Friendship friendship = new Friendship(user, friend, false);
            friendshipRepository.save(friendship);
            return;
        }
        Friendship friendship = existingFriendship.get(); 
        if (friendship.friend().id() == userId){
            friendship.isActive(true);
            friendshipRepository.save(friendship);
        }
    }

    public void removeFriend(FriendCommand removeFriendCommand, UUID userId){
        String firendUsername = removeFriendCommand.username();
        User friend = userRepository.findByUsername(firendUsername);
        Optional<Friendship> friendshipOp = friendshipRepository.findSymmetricalFriendship(userId, friend.id());
        if (friendshipOp.isPresent()) {
            friendshipRepository.delete(friendshipOp.get());
        }
    }

    public List<FriendDTO> getFriends(UUID userId){
        List<Friendship> friendships = friendshipRepository.findAllByUserId(userId);
        List<FriendDTO> friendDTOs = friendships.stream()
            .map(friendship -> friendship.toFriendDTO(userId)).toList();
        return friendDTOs;
    }

}
