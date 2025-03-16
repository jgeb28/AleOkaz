package pl.aleokaz.backend.post;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/posts")
public class PostController {
    @Autowired
    private PostService postService;

    @GetMapping
    public ResponseEntity<List<PostDto>> getAllPosts() {
        try {
            List<PostDto> posts = postService.getAllPosts();
            return new ResponseEntity<>(posts, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping("/{postId}")
    public ResponseEntity<PostDto> getPost(@PathVariable UUID postId) {
        try {
            PostDto post = postService.getPostById(postId);
            return ResponseEntity.ok().body(post);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @PostMapping(consumes = "multipart/form-data")
    public ResponseEntity<PostDto> createPost(
        Authentication authentication,
        @RequestPart("post") PostCommand post,
        @RequestParam(value = "image", required = true) MultipartFile image) {

        String currentUserId = (String) authentication.getPrincipal();

        try {
            PostDto createdPost = postService.createPost(UUID.fromString(currentUserId), post, image);
            return ResponseEntity.status(HttpStatus.CREATED).body(createdPost);
        } catch (RuntimeException re) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
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
        } catch (RuntimeException re) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @DeleteMapping("/{postId}")
    public ResponseEntity<PostDto> deletePost(Authentication authentication, @PathVariable UUID postId) {

        UUID currentUserId = UUID.fromString((String) authentication.getPrincipal());

        try {
            PostDto deletedPost = postService.deletePost(currentUserId, postId);
            return ResponseEntity.status(HttpStatus.NO_CONTENT).body(deletedPost);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

}
