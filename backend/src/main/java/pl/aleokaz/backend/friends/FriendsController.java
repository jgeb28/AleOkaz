package pl.aleokaz.backend.friends;

import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.PathVariable;

import pl.aleokaz.backend.recovery.ResponseMsgDto;

//TODO(marcin): Add tests
@RestController
@RequestMapping("/api/friends")
public class FriendsController {
    @Autowired
    private FriendsService friendsService;

    @GetMapping("/all")
    public ResponseEntity<List<FriendDTO>> getFriends(Authentication authentication) {
        try {
            if(authentication == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
            }
            UUID currentUserId = UUID.fromString((String) authentication.getPrincipal());
            return ResponseEntity.ok().body(friendsService.getFriends(currentUserId));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(List.of());
        }
    }

    @GetMapping("/incoming")
    public ResponseEntity<List<FriendDTO>> getIncomingRequests(Authentication authentication) {
        try {
            if(authentication == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
            }
            UUID currentUserId = UUID.fromString((String) authentication.getPrincipal());
            return ResponseEntity.ok().body(friendsService.getIncomingRequests(currentUserId));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(List.of());
        }
    }

    @GetMapping("/allof/{username}")
    public ResponseEntity<List<FriendDTO>> getFriendsOfUser(@PathVariable String username){
        try {
            return ResponseEntity.ok().body(friendsService.getFriendsOfUser(username));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(List.of());
        }
    }

    @PostMapping("/add")
    public ResponseEntity<ResponseMsgDto> addFriend(Authentication authentication, @RequestBody FriendCommand addFriendCommand) {
        try {
            if(authentication == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
            }
            UUID currentUserId = UUID.fromString((String) authentication.getPrincipal());
            FriendsService.FriendStatus status = friendsService.addFriend(addFriendCommand, currentUserId);
            return ResponseEntity.ok().body(ResponseMsgDto.builder().message(status.name()).build());
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ResponseMsgDto.builder().message("ERROR").build());
        }
    }

    @PostMapping("/remove")
    public ResponseEntity<ResponseMsgDto> removeFriends(Authentication authentication, @RequestBody FriendCommand removeFriendCommand) {
        try {
            if(authentication == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
            }
            UUID currentUserId = UUID.fromString((String) authentication.getPrincipal());
            FriendsService.FriendStatus status =  friendsService.removeFriend(removeFriendCommand, currentUserId);
            return ResponseEntity.ok().body(ResponseMsgDto.builder().message(status.name()).build());
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ResponseMsgDto.builder().message("ERROR").build());
        }
    }

    @PostMapping("/deleterequest")
    public ResponseEntity<ResponseMsgDto> deleteFriendRequest(Authentication authentication, @RequestBody FriendCommand removeFriendCommand) {
        try {
            if(authentication == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
            }
            UUID currentUserId = UUID.fromString((String) authentication.getPrincipal());
            FriendsService.FriendStatus status =  friendsService.deleteFriendRequest(removeFriendCommand, currentUserId);
            return ResponseEntity.ok().body(ResponseMsgDto.builder().message(status.name()).build());
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ResponseMsgDto.builder().message("ERROR").build());
        }
    }
}
