package pl.aleokaz.backend.post;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import pl.aleokaz.backend.user.User;
import pl.aleokaz.backend.user.UserRepository;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
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

    private static final String IMAGE_UPLOAD_DIR = "uploads/images/";

    public PostDto createPost(UUID userId, PostCommand postCommand) throws IOException {
        User author = userRepository.findById(userId)
            .orElseThrow(() -> new RuntimeException("Author not found"));

        String imageUrl = saveImage(postCommand.imageBase64());

        Post post = Post.builder()
            .title(postCommand.title())
            .content(postCommand.content())
            .imageUrl(imageUrl)
            .createdAt(new Date())
            .author(author)
            .build();

        Post savedPost = postRepository.save(post);

        return postMapper.convertPostToPostDto(savedPost);
    }

    public List<PostDto> getAllUserPosts(UUID userId) throws IOException {
        List<Post> posts = postRepository.findByAuthorId(userId);

        return posts.stream()
            .map(post -> postMapper.convertPostToPostDto(post))
            .collect(Collectors.toList());
    }

    public PostDto getPostById(UUID postId) throws IOException {
        Post post = postRepository.findById(postId)
            .orElseThrow(() -> new RuntimeException("Post not found"));

        return postMapper.convertPostToPostDto(post);
    }

    public PostDto updatePost(UUID postId, UpdatePostCommand updatePostCommand) throws IOException {
        Post post = postRepository.findById(postId)
            .orElseThrow(() -> new RuntimeException("Post not found"));

        post.content(updatePostCommand.content());
        post.title(updatePostCommand.title());

        Post savedPost = postRepository.save(post);

        return postMapper.convertPostToPostDto(savedPost);
    }

    public PostDto deletePost(UUID userId, UUID postId) throws IOException {
        Post post = postRepository.findById(postId)
            .orElseThrow(() -> new RuntimeException("Post not found"));

        PostDto responsePost = postMapper.convertPostToPostDto(post);

        postRepository.delete(post);

        return responsePost;
    }

    private String saveImage(String imageBase64) throws IOException {
        // Ensure the directory exists
        File directory = new File(IMAGE_UPLOAD_DIR);
        if (!directory.exists()) {
            directory.mkdirs();
        }

        byte[] decodedBytes = Base64.getDecoder().decode(imageBase64);

        // Generate a unique filename and save the file
        String filename = UUID.randomUUID() + ".png"; // You can change the extension based on the image type
        Path filePath = Paths.get(IMAGE_UPLOAD_DIR + filename);
        Files.write(filePath, decodedBytes);

        // Return the relative path to the saved image
        return filePath.toString();
    }
}
