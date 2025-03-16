package pl.aleokaz.backend.post;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import pl.aleokaz.backend.user.User;
import pl.aleokaz.backend.user.UserRepository;
import pl.aleokaz.backend.user.AuthorizationException;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Base64;
import java.util.Date;
import java.util.List;
import java.util.UUID;
import java.io.File;
import java.nio.file.Path;
import java.util.stream.Collectors;

@Service
public class PostService {
    @Autowired
    private PostRepository postRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PostMapper postMapper;

    private static final String IMAGE_UPLOAD_DIR = "src/main/resources/static/uploads/";

    public PostDto createPost(UUID userId, PostCommand postCommand, MultipartFile image) throws AuthorizationException {
        User author = userRepository.findById(userId)
            .orElseThrow(() -> new RuntimeException("Author not found"));

        String imageUrl;
        try {
            imageUrl = saveImage(image);
        } catch (IOException ioe) {
            return null;
        }

        Post post = Post.builder()
            .content(postCommand.content())
            .imageUrl(imageUrl)
            .createdAt(new Date())
            .author(author)
            .build();

        Post savedPost = postRepository.save(post);

        return postMapper.convertPostToPostDto(savedPost);
    }

    public PostDto updatePost(UUID userId, UUID postId, PostCommand postCommand) throws AuthorizationException {
        Post post = postRepository.findById(postId)
            .orElseThrow(() -> new RuntimeException("Post not found"));

        if(!userId.toString().equals(post.author().id().toString())) {
            throw new AuthorizationException(userId.toString());
        }

        post.content(postCommand.content());
        post.editedAt(new Date());

        Post savedPost = postRepository.save(post);

        return postMapper.convertPostToPostDto(savedPost);
    }

    public PostDto deletePost(UUID userId, UUID postId) throws AuthorizationException {
        Post post = postRepository.findById(postId)
            .orElseThrow(() -> new RuntimeException("Post not found"));

        User author = userRepository.findById(userId)
            .orElseThrow(() -> new RuntimeException("Author not found"));

        if(!userId.toString().equals(post.author().id().toString())) {
            throw new AuthorizationException(userId.toString());
        }

        PostDto responsePost = postMapper.convertPostToPostDto(post);

        postRepository.delete(post);

        return responsePost;
    }

    public List<PostDto> getAllPosts() {
        List<Post> posts = postRepository.findAll();

        return posts.stream()
            .map(post -> postMapper.convertPostToPostDto(post))
            .collect(Collectors.toList());
    }

    public PostDto getPostById(UUID postId) {
        Post post = postRepository.findById(postId)
            .orElseThrow(() -> new RuntimeException("Post not found"));

        return postMapper.convertPostToPostDto(post);
    }

    private String saveImage(MultipartFile image) throws IOException {
        // Ensure the upload directory exists
        File directory = new File(IMAGE_UPLOAD_DIR);
        if (!directory.exists()) {
            directory.mkdirs();
        }

        // Generate a unique filename
        String filename = UUID.randomUUID() + "-" + image.getOriginalFilename();
        Path filePath = Paths.get(IMAGE_UPLOAD_DIR, filename); // Correct way to join paths

        // Save the file
        Files.copy(image.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);

        // Return the relative path (or absolute URL if needed)
        return "/uploads/" + filename;
    }
}
