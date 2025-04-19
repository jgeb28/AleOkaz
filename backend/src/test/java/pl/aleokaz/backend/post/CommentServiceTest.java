package pl.aleokaz.backend.post;

import static org.junit.Assert.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.argThat;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.Date;
import java.util.HashSet;
import java.util.Optional;
import java.util.UUID;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Spy;
import org.mockito.junit.jupiter.MockitoExtension;

import pl.aleokaz.backend.user.User;
import pl.aleokaz.backend.user.UserRepository;

@ExtendWith(MockitoExtension.class)
public class CommentServiceTest {
    @InjectMocks
    private CommentService commentService;

    @Spy
    private InteractionMapper interactionMapper;

    @Mock
    private InteractionRepository interactionRepository;

    @Spy
    private CommentRepository commentRepository;

    @Mock
    private UserRepository userRepository;

    @Test
    public void shouldCreateComment() throws Exception {
        final var author = User.builder()
                .id(UUID.randomUUID())
                .username("user")
                .email("user@example.com")
                .password("")
                .roles(new HashSet<>())
                .build();
        final var post = Post.builder()
                .id(UUID.randomUUID())
                .content("Lorem ipsum dolor sit amet")
                .imageUrl("https://example.com/image.jpg")
                .createdAt(new Date())
                .editedAt(new Date())
                .author(author)
                .reactions(new HashSet<>())
                .build();

        when(userRepository.findById(author.id()))
                .thenReturn(Optional.of(author));
        when(interactionRepository.findById(post.id()))
                .thenReturn(Optional.of(post));
        when(commentRepository.save(any(Comment.class)))
                .thenAnswer(invocation -> {
                    final Comment comment = invocation.getArgument(0);
                    comment.id(UUID.randomUUID());
                    return comment;
                });

        final var command = new CreateCommentCommand(post.id(), "More dolor sit amet");

        final var result = commentService.createComment(author.id(), command);

        assertEquals("More dolor sit amet", result.content());
    }
}
