package pl.aleokaz.backend.util;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

import pl.aleokaz.backend.comment.exceptions.CommentNotFoundException;
import pl.aleokaz.backend.fishingspot.exceptions.FishingSpotNotFoundException;
import pl.aleokaz.backend.friends.exceptions.FriendRequestNotFoundException;
import pl.aleokaz.backend.friends.exceptions.FriendshipNotFoundException;
import pl.aleokaz.backend.image.exceptions.ImageSaveException;
import pl.aleokaz.backend.interaction.exceptions.InteractionNotFoundException;
import pl.aleokaz.backend.post.exceptions.PostNotFoundException;
import pl.aleokaz.backend.recovery.exceptions.TokenNotFoundException;
import pl.aleokaz.backend.security.AuthorizationException;
import pl.aleokaz.backend.user.exceptions.UserExistsException;
import pl.aleokaz.backend.user.exceptions.UserNotFoundException;

@ControllerAdvice
public class GlobalExceptionHandler {
    @ExceptionHandler(CommentNotFoundException.class)
    public ResponseEntity<String> handleCommentNotFoundException(CommentNotFoundException ex) {
        return ResponseEntity.status(404).body("Comment not found: " + ex.getMessage());
    }

    @ExceptionHandler(FishingSpotNotFoundException.class)
    public ResponseEntity<String> handleFishingSpotNotFoundException(FishingSpotNotFoundException ex) {
        return ResponseEntity.status(404).body("Fishing spot not found: " + ex.getMessage());
    }

    @ExceptionHandler(FriendRequestNotFoundException.class)
    public ResponseEntity<String> handleFriendRequestNotFoundException(FriendRequestNotFoundException ex) {
        return ResponseEntity.status(404).body("Friend request not found: " + ex.getMessage());
    }
    
    @ExceptionHandler(FriendshipNotFoundException.class)
    public ResponseEntity<String> handleFriendshipNotFoundException(FriendshipNotFoundException ex) {
        return ResponseEntity.status(404).body("Friendship not found: " + ex.getMessage());
    }

    @ExceptionHandler(ImageSaveException.class)
    public ResponseEntity<String> handleImageSaveException(ImageSaveException ex) {
        return ResponseEntity.status(500).body("Image save error: " + ex.getMessage());
    }

    @ExceptionHandler(InteractionNotFoundException.class)
    public ResponseEntity<String> handleInteractionNotFoundException(InteractionNotFoundException ex) {
        return ResponseEntity.status(404).body("Interaction not found: " + ex.getMessage());
    }

    @ExceptionHandler(PostNotFoundException.class)
    public ResponseEntity<String> handlePostNotFoundException(PostNotFoundException ex) {
        return ResponseEntity.status(404).body("Post not found: " + ex.getMessage());
    }

    @ExceptionHandler(TokenNotFoundException.class)
    public ResponseEntity<String> handleTokenNotFoundException(TokenNotFoundException ex) {
        return ResponseEntity.status(404).body("Token not found: " + ex.getMessage());
    }

    @ExceptionHandler(UserNotFoundException.class)
    public ResponseEntity<String> handleUserNotFoundException(UserNotFoundException ex) {
        return ResponseEntity.status(404).body("User not found: " + ex.getMessage());
    }

    @ExceptionHandler(UserExistsException.class)
    public ResponseEntity<String> handleUserExistsException(UserExistsException ex) {
        return ResponseEntity.status(409).body("User already exists: " + ex.getMessage());
    }

    @ExceptionHandler(AuthorizationException.class)
    public ResponseEntity<String> handleAuthorizationException(AuthorizationException ex) {
        return ResponseEntity.status(403).body("Authorization error: " + ex.getMessage());
    }

    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<String> handleIllegalArgumentException(IllegalArgumentException ex) {
        return ResponseEntity.status(400).body("Invalid argument: " + ex.getMessage());
    }
    
    @ExceptionHandler(Exception.class)
    public ResponseEntity<String> handleGeneralException(Exception ex) {
        ex.printStackTrace();
        return ResponseEntity.status(500).body("An unexpected error has occured");
    }
}
