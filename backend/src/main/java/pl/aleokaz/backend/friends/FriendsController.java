package pl.aleokaz.backend.friends;

import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import org.springframework.web.bind.annotation.PathVariable;

import pl.aleokaz.backend.security.AuthenticationService;
import pl.aleokaz.backend.user.User;
import pl.aleokaz.backend.user.UserService;

@RestController
@RequestMapping("/api/friends")
public class FriendsController {
    @Autowired
    private FriendsService friendsService;
    @Autowired
    private UserService userService;
    @Autowired
    private AuthenticationService authenticationService;

    @GetMapping("/my")
    public ResponseEntity<List<FriendDTO>> getFriends(Authentication authentication) {
        UUID currentUserId = authenticationService.getCurrentUserId(authentication);
        List<User> friends = friendsService.getFriends(currentUserId);
        return new ResponseEntity<>(FriendsService.usersAsFriendDtos(friends), HttpStatus.OK);
    }

    @GetMapping("/username/{username}")
    public ResponseEntity<List<FriendDTO>> getFriendsOfUser(Authentication authentication, @PathVariable String username){
        UUID currentUserId = authenticationService.getCurrentUserId(authentication);
        List<User> friends = friendsService.getFriendsOfUser(username, currentUserId);
        return new ResponseEntity<>(FriendsService.usersAsFriendDtos(friends), HttpStatus.OK);
    }

    @DeleteMapping("/{username}")
    public ResponseEntity<Void> removeFriends(Authentication authentication, @PathVariable String username) {
        UUID currentUserId = authenticationService.getCurrentUserId(authentication);
        friendsService.removeFriend(currentUserId, userService.getUserByUsername(username).id());
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @GetMapping("/requests/received")
    public ResponseEntity<List<FriendDTO>> getIncomingRequests(Authentication authentication) {
        UUID currentUserId = authenticationService.getCurrentUserId(authentication);
        List<FriendRequest> incomingRequests = friendsService.getIncomingFriendRequests(currentUserId);
        return new ResponseEntity<>(FriendsService.friendRequestsAsFriendDtos(incomingRequests, currentUserId), HttpStatus.OK);
    }

    @GetMapping("/requests/sent")
    public ResponseEntity<List<FriendDTO>> getSentRequests(Authentication authentication) {
        UUID currentUserId = authenticationService.getCurrentUserId(authentication);
        List<FriendRequest> incomingRequests = friendsService.getSentFriendRequests(currentUserId);
        return new ResponseEntity<>(FriendsService.friendRequestsAsFriendDtos(incomingRequests, currentUserId), HttpStatus.OK);
    }

    @PostMapping("/requests/send/{username}")
    public ResponseEntity<Void> sendFriendRequest(Authentication authentication, @PathVariable String username) {
        UUID currentUserId = authenticationService.getCurrentUserId(authentication);
        friendsService.sendFriendRequest(currentUserId, userService.getUserByUsername(username).id());
        return new ResponseEntity<>(HttpStatus.CREATED);
    }

    @DeleteMapping("/requests/cancel/{username}")
    public ResponseEntity<Void> deleteFriendRequest(Authentication authentication, @PathVariable String username) {
        UUID currentUserId = authenticationService.getCurrentUserId(authentication);
        friendsService.cancelFriendRequest(currentUserId, userService.getUserByUsername(username).id());
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @PostMapping("/requests/accept/{username}")
    public ResponseEntity<Void> acceptFriendRequest(Authentication authentication, @PathVariable String username) {
        UUID currentUserId = authenticationService.getCurrentUserId(authentication);
        friendsService.acceptFriendRequest(currentUserId, userService.getUserByUsername(username).id());
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @PostMapping("/requests/decline/{username}")
    public ResponseEntity<Void> declineFriendRequest(Authentication authentication, @PathVariable String username) {
        UUID currentUserId = authenticationService.getCurrentUserId(authentication);
        friendsService.denyFriendRequest(currentUserId, userService.getUserByUsername(username).id());
        return new ResponseEntity<>(HttpStatus.OK);
    }
}
