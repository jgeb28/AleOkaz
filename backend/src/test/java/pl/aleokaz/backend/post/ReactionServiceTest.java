package pl.aleokaz.backend.post;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import pl.aleokaz.backend.interaction.InteractionService;
import pl.aleokaz.backend.reaction.ReactionService;
import pl.aleokaz.backend.reaction.ReactionType;
import pl.aleokaz.backend.reaction.commands.ReactionCommand;
import pl.aleokaz.backend.user.User;
import pl.aleokaz.backend.user.UserService;

import java.util.Date;
import java.util.HashSet;
import java.util.UUID;

@ExtendWith(MockitoExtension.class)
public class ReactionServiceTest {
    @InjectMocks
    private ReactionService reactionService;

    @Mock
    private InteractionService interactionService;

    @Mock
    private UserService userService;

    @Test
    public void shouldSetPostReaction() throws Exception {
        final var author = User.builder()
                .id(UUID.randomUUID())
                .username("user")
                .password("")
                .roles(new HashSet<>())
                .profilePicture("empty")
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

        when(userService.getUserById(author.id()))
                .thenReturn(author);
        when(interactionService.getInteractionById(post.id()))
                .thenReturn(post);
        reactionService.setReaction(author.id(), post.id(), new ReactionCommand(null, ReactionType.LIKE));

        verify(interactionService).saveInteraction(
                argThat(savedPost -> savedPost.reactions().stream()
                        .anyMatch(reaction -> reaction.type().equals(ReactionType.LIKE) &&
                                reaction.author().equals(author) &&
                                reaction.interaction().equals(post))));
    }
}
