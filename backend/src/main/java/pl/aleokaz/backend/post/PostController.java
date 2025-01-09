package pl.aleokaz.backend.post;

import org.apache.coyote.Response;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/users/posts/{userId}")
public class PostController {
    @Autowired
    private PostService postService;

    @GetMapping
    public ResponseEntity<List<PostDto>> getAllPosts(@PathVariable UUID userId) {
        try {
            List<PostDto> posts = postService.getAllUserPosts(userId);
            return new ResponseEntity<>(posts, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping("/{postId}")
    public ResponseEntity<PostDto> getPost(@PathVariable UUID userId, @PathVariable UUID postId) {
        try {
            PostDto post = postService.getPostById(postId);
            return ResponseEntity.ok().body(post);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @PutMapping("/{postId}")
    public ResponseEntity<PostDto> updatePost(@PathVariable UUID userId, @PathVariable UUID postId, @RequestBody UpdatePostCommand updatePostCommand) {
        try {
            PostDto post = postService.updatePost(postId, updatePostCommand);
            return ResponseEntity.ok().body(post);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @PostMapping
    public ResponseEntity<PostDto> createPost(@PathVariable UUID userId, @RequestBody PostCommand post) {
        try {
            PostDto createdPost = postService.createPost(userId, post);
            return ResponseEntity.status(HttpStatus.CREATED).body(createdPost);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }

    @DeleteMapping("/{postId}")
    public ResponseEntity<PostDto> deletePost(@PathVariable UUID userId, @PathVariable UUID postId, Authentication authentication) {
        //TODO set up id check better
        String currentUserId = (String) authentication.getPrincipal();

        if (!currentUserId.equals(userId.toString())) {
            throw new RuntimeException("Access denied: You can only delete your posts.");
        }

        try {
            PostDto deletedPost = postService.deletePost(userId, postId);
            return ResponseEntity.status(HttpStatus.NO_CONTENT).body(deletedPost);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(null);
        }
    }
}
