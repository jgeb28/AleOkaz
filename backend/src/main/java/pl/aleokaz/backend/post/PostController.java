package pl.aleokaz.backend.post;

import org.apache.coyote.Response;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/users/posts/{userId}")
public class PostController {
    @Autowired
    private PostService postService;

    @GetMapping
    public ResponseEntity<String> getPosts(@PathVariable UUID userId) {


        return ResponseEntity.status(HttpStatus.OK).body("cool");
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
}
