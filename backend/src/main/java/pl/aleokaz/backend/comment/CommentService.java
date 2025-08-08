package pl.aleokaz.backend.comment;

import pl.aleokaz.backend.comment.exceptions.CommentNotFoundException;
import pl.aleokaz.backend.interaction.Interaction;
import pl.aleokaz.backend.interaction.InteractionService;
import pl.aleokaz.backend.user.User;
import pl.aleokaz.backend.user.UserService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import jakarta.transaction.Transactional;
import lombok.NonNull;

import java.util.Date;
import java.util.UUID;

@Service
@Transactional
public class CommentService {
    @Autowired
    private UserService userService;

    @Autowired
    private CommentRepository commentRepository;

    @Autowired
    private InteractionService interactionService;

    @Value("${aleokaz.comment.deleted.content}")
    private String deletedCommentContent;

    public Comment getCommentById(@NonNull UUID commentId) {
        return commentRepository.findById(commentId)
                .orElseThrow(() -> new CommentNotFoundException("id", commentId.toString()));
    }
    
    public Comment createComment(@NonNull UUID userId, @NonNull UUID parentInteractionId, @NonNull String content) {
        User user = userService.getUserById(userId);
        Interaction parentInteraction = interactionService.getInteractionById(parentInteractionId);

        var comment = Comment.builder()
                .content(content)
                .createdAt(new Date())
                .author(user)
                .parent(parentInteraction)
                .build();
        return commentRepository.save(comment);
    }

    public Comment updateComment(@NonNull UUID userId, @NonNull UUID commentId, @NonNull String newContent) {
        User user = userService.getUserById(userId);
        Comment comment = getCommentById(commentId);

        user.verifyAs(comment.author());

        comment.content(newContent);
        comment.editedAt(new Date());
        return commentRepository.save(comment);
    }

    public Comment deleteCommentAsUser(@NonNull UUID userId, @NonNull UUID commentId) {
        User user = userService.getUserById(userId);
        Comment comment = getCommentById(commentId);

        user.verifyAs(comment.author());
        comment.author(null);
        comment.content(deletedCommentContent);
        comment.editedAt(new Date());
        return commentRepository.save(comment);
    }
}
