package pl.aleokaz.backend.post;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Spy;
import org.mockito.junit.jupiter.MockitoExtension;

import pl.aleokaz.backend.user.User;
import pl.aleokaz.backend.user.UserRepository;

import java.util.Date;
import java.util.HashSet;
import java.util.Optional;
import java.util.UUID;

@ExtendWith(MockitoExtension.class)
public class PostServiceTest {
    @InjectMocks
    private PostService postService;

    @Spy
    private PostMapper postMapper;

    @Mock
    private PostRepository postRepository;

    @Mock
    private UserRepository userRepository;

    @Test
    public void shouldSetPostReaction() throws Exception {
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

        postService.setPostReaction(post.id(), author.id(), PostReactionType.LIKE);

        verify(postRepository).save(
                argThat(savedPost -> savedPost.reactions().stream()
                        .anyMatch(reaction -> reaction.type().equals(PostReactionType.LIKE) &&
                                reaction.author().equals(author) &&
                                reaction.post().equals(post))));
    }
}
