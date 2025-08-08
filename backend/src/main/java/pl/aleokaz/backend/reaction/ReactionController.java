package pl.aleokaz.backend.reaction;

import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import pl.aleokaz.backend.reaction.commands.ReactionCommand;
import pl.aleokaz.backend.security.AuthenticationService;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;

@RestController
@RequestMapping("/api/reactions")
public class ReactionController {
    @Autowired
    private AuthenticationService authenticationService;

    @Autowired
    private ReactionService reactionService;

    @PutMapping("/{interactionId}")
    public ResponseEntity<Void> setPostReaction(Authentication authentication, @PathVariable String interactionId,
                @RequestBody ReactionCommand reactionCommand) {
        UUID userId = authenticationService.getCurrentUserId(authentication);
        reactionService.setReaction(userId, UUID.fromString(interactionId), reactionCommand);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @DeleteMapping("/{interactionId}")
    public ResponseEntity<Void> deletePostReaction(Authentication authentication, @PathVariable UUID interactionId) {
        UUID userId = authenticationService.getCurrentUserId(authentication);
        reactionService.deleteReaction(userId, interactionId);
        return new ResponseEntity<>(HttpStatus.OK);
    }
}
