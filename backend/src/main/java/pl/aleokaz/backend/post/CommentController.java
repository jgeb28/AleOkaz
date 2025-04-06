package pl.aleokaz.backend.post;

import pl.aleokaz.backend.user.AuthorizationException;

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
    private CommentService commentService;

    @PostMapping
    public ResponseEntity<CommentDto> createComment(
            Authentication authentication,
            @RequestBody CreateCommentCommand command) {
        final var currentUserId = UUID.fromString((String) authentication.getPrincipal());

        try {
            final var createdComment = commentService.createComment(currentUserId, command);
            return ResponseEntity.status(HttpStatus.CREATED).body(createdComment);
        } catch (AuthorizationException ae) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(null);
        }
    }

    @PutMapping("/{commentId}")
    public ResponseEntity<CommentDto> updateComment(
            Authentication authentication,
            @PathVariable UUID commentId,
            @RequestBody UpdateCommentCommand command) {
        final var currentUserId = UUID.fromString((String) authentication.getPrincipal());

        command.commentId(commentId);
        System.out.println("Command: " + command);
        try {
            final var comment = commentService.updateComment(currentUserId, command);
            return ResponseEntity.ok().body(comment);
        } catch (AuthorizationException ae) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(null);
        }
    }

    @DeleteMapping("/{commentId}")
    public ResponseEntity<Void> deleteComment(Authentication authentication, @PathVariable UUID commentId) {
        final var currentUserId = UUID.fromString((String) authentication.getPrincipal());

        try {
            commentService.deleteComment(currentUserId, commentId);
            return ResponseEntity.noContent().build();
        } catch (AuthorizationException ae) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(null);
        }
    }
}
