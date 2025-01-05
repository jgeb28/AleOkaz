package pl.aleokaz.backend.friends;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import pl.aleokaz.backend.recovery.ResponseMsgDto;

@RestController
@RequestMapping("/api/friends")
public class FriendsController {
    @Autowired
    private FriendsService friendsService;

    @GetMapping("/all")
    public ResponseEntity<List<FriendDTO>> findUserById() {
        try {
            return ResponseEntity.ok().body(friendsService.getFriends(null)); //TODO: Get friend Id from verification
        } catch (Exception e) {
            return null;
        }
    }

    @PostMapping("/add")
    public ResponseEntity<ResponseMsgDto> registerUser(@RequestBody FriendCommand addFriendCommand) {
        try {
            friendsService.addFriend(addFriendCommand, null); //TODO: Get friend Id from verification
            return ResponseEntity.ok().body(ResponseMsgDto.builder().message("Added a friend.").build());
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ResponseMsgDto.builder().message("An issue occured while adding a friend.").build());
        }
    }

    @PostMapping("/remove")
    public ResponseEntity<ResponseMsgDto> loginUser(@RequestBody FriendCommand removeFriendCommand) {
        try {
            friendsService.removeFriend(removeFriendCommand, null); //TODO: Get friend Id from verification
            return ResponseEntity.ok().body(ResponseMsgDto.builder().message("Recovery code sent.").build());
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ResponseMsgDto.builder().message("An issue occured while generating recovery code.").build());
        }
    }
}
