package pl.aleokaz.backend.post;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import pl.aleokaz.backend.user.AuthorizationException;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/posts")
public class PostController {
    @Autowired
    private PostService postService;

    @Autowired
    private ReactionService reactionService;

    @GetMapping
    public ResponseEntity<List<PostDto>> getAllPosts(
            Authentication authentication,
            @RequestParam(name = "userId", required = false) UUID authorId) {
        UUID userId = null;
        if (authentication != null) {
            userId = UUID.fromString((String) authentication.getPrincipal());
        }

        List<PostDto> posts;

        if (authorId != null) {
            posts = postService.getPostsByUserId(userId, authorId);
        } else {
            posts = postService.getAllPosts(userId);
        }

        return new ResponseEntity<>(posts, HttpStatus.OK);
    }

    @GetMapping("/{postId}")
    public ResponseEntity<PostDto> getPost(
            Authentication authentication,
            @PathVariable UUID postId) {
        UUID userId = null;
        if (authentication != null) {
            userId = UUID.fromString((String) authentication.getPrincipal());
        }

        PostDto post = postService.getPostById(userId, postId);
        return ResponseEntity.ok().body(post);
    }

    @PostMapping(consumes = "multipart/form-data")
    public ResponseEntity<PostDto> createPost(
            Authentication authentication,
            @RequestPart("post") PostCommand post,
            @RequestParam(value = "image", required = true) MultipartFile image) {

        UUID currentUserId = UUID.fromString((String) authentication.getPrincipal());

        try {
            PostDto createdPost = postService.createPost(currentUserId, post, image);
            return ResponseEntity.status(HttpStatus.CREATED).body(createdPost);
        } catch (ImageSaveException pse) {
            return ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE).body(null);
        }
    }

    @PutMapping("/{postId}")
    public ResponseEntity<PostDto> updatePost(
            Authentication authentication,
            @PathVariable UUID postId,
            @RequestPart("post") PostCommand postCommand) {

        UUID currentUserId = UUID.fromString((String) authentication.getPrincipal());

        try {
            PostDto post = postService.updatePost(currentUserId, postId, postCommand);
            return ResponseEntity.ok().body(post);
        } catch (AuthorizationException ae) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(null);
        }
    }

    @DeleteMapping("/{postId}")
    public ResponseEntity<PostDto> deletePost(Authentication authentication, @PathVariable UUID postId) {

        UUID currentUserId = UUID.fromString((String) authentication.getPrincipal());

        try {
            postService.deletePost(currentUserId, postId);
            return ResponseEntity.noContent().build();
        } catch (AuthorizationException ae) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(null);
        }
    }

    @PutMapping("/{postId}/reactions")
    public ResponseEntity<Void> setPostReaction(
            Authentication authentication,
            @PathVariable UUID postId) {
        final UUID userId = UUID.fromString((String) authentication.getPrincipal());

        // TODO: Wczytanie typu reakcji z @RequestBody.
        reactionService.setReaction(userId, new ReactionCommand(postId, ReactionType.LIKE));

        return ResponseEntity.noContent().build();
    }

    @DeleteMapping("/{postId}/reactions")
    public ResponseEntity<Void> deletePostReaction(
            Authentication authentication,
            @PathVariable UUID postId) {
        final UUID userId = UUID.fromString((String) authentication.getPrincipal());

        reactionService.deleteReaction(userId, postId);

        return ResponseEntity.noContent().build();
    }
}
