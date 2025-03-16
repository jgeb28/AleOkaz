package pl.aleokaz.backend.friends;

import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import pl.aleokaz.backend.recovery.ResponseMsgDto;

//TODO(marcin): Change when authentication is implemented
//TODO(marcin): Kafka messaging about friendship
//TODO(marcin): Add tests
@RestController
@RequestMapping("/api/friends")
public class FriendsController {
    @Autowired
    private FriendsService friendsService;

    @GetMapping("/all")
    public ResponseEntity<List<FriendDTO>> getFriends(Authentication authentication) {
        try {
            UUID currentUserId = UUID.fromString((String) authentication.getPrincipal());
            return ResponseEntity.ok().body(friendsService.getFriends(currentUserId));
        } catch (Exception e) {
            return null;
        }
    }
    
    @PostMapping("/add")
    public ResponseEntity<ResponseMsgDto> addFriend(Authentication authentication, @RequestBody FriendCommand addFriendCommand) {
        try {
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
            UUID currentUserId = UUID.fromString((String) authentication.getPrincipal());
            FriendsService.FriendStatus status =  friendsService.removeFriend(removeFriendCommand, currentUserId);
            return ResponseEntity.ok().body(ResponseMsgDto.builder().message(status.name()).build());
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ResponseMsgDto.builder().message("ERROR").build());
        }
    }
}
