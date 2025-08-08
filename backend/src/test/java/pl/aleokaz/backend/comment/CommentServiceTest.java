package pl.aleokaz.backend.comment;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.Date;
import java.util.HashSet;
import java.util.UUID;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Spy;
import org.mockito.junit.jupiter.MockitoExtension;
import org.mockito.junit.jupiter.MockitoSettings;
import org.mockito.quality.Strictness;
import org.springframework.test.util.ReflectionTestUtils;

import pl.aleokaz.backend.comment.exceptions.CommentNotFoundException;
import pl.aleokaz.backend.interaction.InteractionService;
import pl.aleokaz.backend.interaction.exceptions.InteractionNotFoundException;
import pl.aleokaz.backend.post.Post;
import pl.aleokaz.backend.security.AuthorizationException;
import pl.aleokaz.backend.user.User;
import pl.aleokaz.backend.user.UserService;

@ExtendWith(MockitoExtension.class)
@MockitoSettings(strictness = Strictness.LENIENT)
public class CommentServiceTest {
    @InjectMocks
    private CommentService commentService;

    @Mock
    private InteractionService interactionService;

    @Spy
    private CommentRepository commentRepository;

    @Mock
    private UserService userService;

    private User author, anotherUser;
    private Post post;
    private Comment comment;
    private String deletedCommentContent = "This comment has been deleted.";

    @BeforeEach
    public void setUp() {
        author = User.builder()
                .id(UUID.randomUUID())
                .username("user")
                .password("")
                .roles(new HashSet<>())
                .profilePicture("empty")
                .build();
        post = Post.builder()
                .id(UUID.randomUUID())
                .content("Lorem ipsum dolor sit amet")
                .imageUrl("https://example.com/image.jpg")
                .createdAt(new Date())
                .editedAt(new Date())
                .author(author)
                .reactions(new HashSet<>())
                .build();
        comment = Comment.builder()
                .id(UUID.randomUUID())
                .content("This is a comment")
                .createdAt(new Date())
                .author(author)
                .parent(post)
                .reactions(new HashSet<>())
                .comments(new HashSet<>())
                .build();
        anotherUser = User.builder()
                .id(UUID.randomUUID())
                .username("anotherUser")
                .password("")
                .roles(new HashSet<>())
                .profilePicture("empty")
                .build();
        
        when(userService.getUserById(anotherUser.id()))
                .thenReturn(anotherUser);
        when(commentRepository.findById(comment.id()))
                .thenReturn(java.util.Optional.of(comment));
        when(commentRepository.save(any(Comment.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));
        when(userService.getUserById(author.id()))
                .thenReturn(author);
        when(interactionService.getInteractionById(post.id()))
                .thenReturn(post);

        ReflectionTestUtils.setField(commentService, "deletedCommentContent", deletedCommentContent);
    }

    @Test
    public void shouldCreateComment() throws Exception {
        String testContent = "Lorem ipsum dolor sit amet";

        when(commentRepository.save(any(Comment.class)))
                .thenAnswer(invocation -> {
                    final Comment comment = invocation.getArgument(0);
                    comment.id(UUID.randomUUID());
                    return comment;
                });
        Comment result = commentService.createComment(author.id(), post.id(), testContent);

        assertEquals(testContent, result.content());
        verify(commentRepository).save(result);
    }

    @Test
    public void shouldUpdateComment() throws Exception {
        String updatedContent = "Updated content";

        when(commentRepository.findById(comment.id()))
                .thenReturn(java.util.Optional.of(comment));
        when(commentRepository.save(any(Comment.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));
        when(userService.getUserById(author.id()))
                .thenReturn(author);
        Comment updatedComment = commentService.updateComment(author.id(), comment.id(), updatedContent);
        assertEquals(updatedContent, updatedComment.content());
        verify(commentRepository).save(updatedComment);
    }

    @Test
    public void shouldDeleteCommentAsUser() throws Exception {
        Comment deletedComment = commentService.deleteCommentAsUser(author.id(), comment.id());
        assertEquals(deletedCommentContent, deletedComment.content());
        assertEquals(null, deletedComment.author());
        verify(commentRepository).save(deletedComment);
    }

    @Test
    public void shouldNotCreateCommentWithNullContent() {
        assertThrows(NullPointerException.class, () -> 
            commentService.createComment(author.id(), post.id(), null));
    }

    @Test
    public void shouldNotUpdateCommentWithNullContent() {
        when(commentRepository.findById(comment.id()))
                .thenReturn(java.util.Optional.of(comment));
        when(userService.getUserById(author.id()))
                .thenReturn(author);

        assertThrows(NullPointerException.class, () -> 
            commentService.updateComment(author.id(), comment.id(), null));
    }

    @Test
    public void shouldNotCreateCommentOnNonExistantInteraction() {
        UUID nonExistentInteractionId = UUID.randomUUID();
        String content = "This is a comment";

        when(interactionService.getInteractionById(nonExistentInteractionId))
                .thenThrow(new InteractionNotFoundException("id", nonExistentInteractionId.toString()));

        assertThrows(InteractionNotFoundException.class, () -> 
            commentService.createComment(author.id(), nonExistentInteractionId, content));
    }

    @Test
    public void shouldNotUpdateNonExistantComment() {
        UUID nonExistentCommentId = UUID.randomUUID();
        String newContent = "Updated content";

        when(commentRepository.findById(nonExistentCommentId))
                .thenReturn(java.util.Optional.empty());

        assertThrows(CommentNotFoundException.class, () -> 
            commentService.updateComment(author.id(), nonExistentCommentId, newContent));
    }

    @Test
    public void shouldNotDeleteNonExistantComment() {
        UUID nonExistentCommentId = UUID.randomUUID();
        when(commentRepository.findById(nonExistentCommentId))
                .thenReturn(java.util.Optional.empty());
        assertThrows(CommentNotFoundException.class, () -> 
            commentService.deleteCommentAsUser(author.id(), nonExistentCommentId));
    }

    @Test
    public void shouldNotDeleteCommentAsDifferentUser() {
        assertThrows(AuthorizationException.class, () -> 
            commentService.deleteCommentAsUser(anotherUser.id(), comment.id()));
    }

    @Test
    public void shouldNotUpdateCommentAsDifferentUser() {
        assertThrows(AuthorizationException.class, () -> 
            commentService.updateComment(anotherUser.id(), comment.id(), "New content"));
    }
}
