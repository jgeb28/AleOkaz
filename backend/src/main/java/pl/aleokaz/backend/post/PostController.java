package pl.aleokaz.backend.post;

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

    @GetMapping
    public ResponseEntity<List<PostDto>> getAllPosts() {
        List<PostDto> posts = postService.getAllPosts();
        return new ResponseEntity<>(posts, HttpStatus.OK);
    }

    @GetMapping("/{postId}")
    public ResponseEntity<PostDto> getPost(@PathVariable UUID postId) {
        PostDto post = postService.getPostById(postId);
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
        } catch (PostSaveException pse) {
            return ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE).body(null);
        } catch (RuntimeException re) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
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
        } catch (RuntimeException re) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
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
        } catch (RuntimeException re) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
        }
    }

    @PutMapping("/{postId}/reactions")
    public ResponseEntity<Void> setPostReaction(
            Authentication authentication,
            @PathVariable UUID postId) {
        final UUID userId = UUID.fromString((String) authentication.getPrincipal());

        // TODO: Wczytanie typu reakcji z @RequestBody.
        postService.setPostReaction(postId, userId, PostReactionType.LIKE);

        return ResponseEntity.ok(null);
    }

    @DeleteMapping("/{postId}/reactions")
    public ResponseEntity<Void> unreactToPost(
            Authentication authentication,
            @PathVariable UUID postId) {
        final UUID userId = UUID.fromString((String) authentication.getPrincipal());

        postService.deletePostReaction(postId, userId);

        return ResponseEntity.ok(null);
    }

}
