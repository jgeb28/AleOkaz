package pl.aleokaz.backend.comment;

import pl.aleokaz.backend.comment.commands.CreateCommentCommand;
import pl.aleokaz.backend.comment.commands.UpdateCommentCommand;
import pl.aleokaz.backend.security.AuthenticationService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/api/comments")
public class CommentController {
    @Autowired
    private AuthenticationService authenticationService;

    @Autowired
    private CommentService commentService;

    @PostMapping("/{parentId}")
    public ResponseEntity<CommentDTO> createComment(Authentication authentication,
                @RequestBody CreateCommentCommand createCommentCommand,
                @PathVariable UUID parentId) {
        UUID currentUserId = authenticationService.getCurrentUserId(authentication);
        Comment comment = commentService.createComment(currentUserId, parentId,
                createCommentCommand.content());
        return new ResponseEntity<>(comment.asCommentDto(), HttpStatus.CREATED);
    }

    @PutMapping("/{commentId}")
    public ResponseEntity<CommentDTO> updateComment(Authentication authentication, @PathVariable UUID commentId,
                @RequestBody UpdateCommentCommand command) {
        UUID currentUserId = authenticationService.getCurrentUserId(authentication);
        Comment comment = commentService.updateComment(currentUserId, commentId, command.content());
        if (comment == null)
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        return new ResponseEntity<>(comment.asCommentDto(), HttpStatus.OK);
    }

    @DeleteMapping("/{commentId}")
    public ResponseEntity<Void> deleteComment(Authentication authentication, @PathVariable UUID commentId) {
        UUID currentUserId = authenticationService.getCurrentUserId(authentication);
        commentService.deleteCommentAsUser(currentUserId, commentId);
        return new ResponseEntity<>(HttpStatus.OK);
    }
}
