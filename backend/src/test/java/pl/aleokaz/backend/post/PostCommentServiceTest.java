package pl.aleokaz.backend.post;

import static org.mockito.ArgumentMatchers.argThat;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.Date;
import java.util.HashSet;
import java.util.Optional;
import java.util.UUID;

import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Spy;

import pl.aleokaz.backend.user.User;
import pl.aleokaz.backend.user.UserRepository;

public class PostCommentServiceTest {
        @InjectMocks
        private CommentService postCommentService;

        @Spy
        private InteractionMapper postMapper;

        @Mock
        private PostRepository postRepository;

        @Mock
        private CommentRepository postCommentRepository;

        @Mock
        private UserRepository userRepository;

        @Test
        public void shouldCreatePostComment() throws Exception {
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
                when(postRepository.findById(post.id()))
                                .thenReturn(Optional.of(post));

                final var command = new CreateCommentCommand(post.id(), "More dolor sit amet");

                postCommentService.createComment(author.id(), command);

                verify(postCommentRepository).save(
                                argThat(savedComment -> savedComment.content().equals(command.content())));
        }
}
