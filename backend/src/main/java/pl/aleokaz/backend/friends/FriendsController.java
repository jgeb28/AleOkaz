package pl.aleokaz.backend.friends;

import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
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

    @GetMapping("/all/{id}")
    public ResponseEntity<List<FriendDTO>> getFriends(@PathVariable UUID id) {
        try {
            return ResponseEntity.ok().body(friendsService.getFriends(id)); //TODO: Get friend Id from verification
        } catch (Exception e) {
            return null;
        }
    }
    
    @PostMapping("/add/{id}")
    public ResponseEntity<ResponseMsgDto> addFriend(@RequestBody FriendCommand addFriendCommand, @PathVariable UUID id) {
        try {
            FriendsService.FriendStatus status = friendsService.addFriend(addFriendCommand, id); //TODO: Get friend Id from verification
            return ResponseEntity.ok().body(ResponseMsgDto.builder().message(status.name()).build());
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ResponseMsgDto.builder().message("ERROR").build());
        }
    }

    @PostMapping("/remove/{id}")
    public ResponseEntity<ResponseMsgDto> removeFriends(@RequestBody FriendCommand removeFriendCommand, @PathVariable UUID id) {
        try {
            FriendsService.FriendStatus status =  friendsService.removeFriend(removeFriendCommand, id); //TODO: Get friend Id from verification
            return ResponseEntity.ok().body(ResponseMsgDto.builder().message(status.name()).build());
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ResponseMsgDto.builder().message("ERROR").build());
        }
    }
}
