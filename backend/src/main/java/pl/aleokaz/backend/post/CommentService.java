package pl.aleokaz.backend.post;

import pl.aleokaz.backend.exceptions.UserNotFoundException;
import pl.aleokaz.backend.user.AuthorizationException;
import pl.aleokaz.backend.user.UserRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import jakarta.transaction.Transactional;
import lombok.NonNull;

import java.util.Date;
import java.util.UUID;

@Service
@Transactional
public class CommentService {
    @Autowired
    private UserRepository userRepository;

    @Autowired
    private CommentRepository commentRepository;

    @Autowired
    private InteractionRepository interactionRepository;

    @Autowired
    private InteractionMapper postMapper;

    public CommentDto createComment(@NonNull UUID userId, @NonNull CreateCommentCommand command) {
        final var author = userRepository.findById(userId)
                .orElseThrow(() -> new UserNotFoundException("id", userId.toString()));
        final var parent = interactionRepository.findById(command.parentId())
                .orElseThrow(() -> new RuntimeException("Interaction not found"));

        var comment = Comment.builder()
                .content(command.content())
                .createdAt(new Date())
                .author(author)
                .parent(parent)
                .build();
        comment = commentRepository.save(comment);

        return postMapper.convertCommentToCommentDto(comment, author);
    }

    public CommentDto updateComment(@NonNull UUID userId, @NonNull UpdateCommentCommand command) {
        final var author = userRepository.findById(userId)
                .orElseThrow(() -> new UserNotFoundException("id", userId.toString()));
        var comment = commentRepository.findById(command.commentId())
                .orElseThrow(() -> new RuntimeException("Comment not found"));

        if (!author.equals(comment.author())) {
            throw new AuthorizationException(userId.toString());
        }

        comment.content(command.content());
        comment.editedAt(new Date());

        comment = commentRepository.save(comment);

        return postMapper.convertCommentToCommentDto(comment, author);
    }

    public void deleteComment(@NonNull UUID userId, @NonNull UUID commentId) {
        final var comment = commentRepository.findById(commentId)
                .orElseThrow(() -> new RuntimeException("Comment not found"));

        if (!userId.equals(comment.author().id())) {
            throw new AuthorizationException(userId.toString());
        }

        // TODO: Nie usuwać podkomentarzy tylko zrobić coś (ale co?).
        commentRepository.delete(comment);
    }
}
