package pl.aleokaz.backend.post;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import pl.aleokaz.backend.user.User;
import pl.aleokaz.backend.user.UserRepository;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Base64;
import java.util.Date;
import java.util.UUID;
import java.io.File;
import java.nio.file.Path;

@Service
public class PostService {
    @Autowired
    private PostRepository postRepository;

    @Autowired
    private UserRepository userRepository;

    private static final String IMAGE_UPLOAD_DIR = "uploads/images/";

    public PostDto createPost(UUID userId, PostCommand postCommand) throws IOException {
        // Fetch the author from the database
        User author = userRepository.findById(userId)
            .orElseThrow(() -> new RuntimeException("Author not found"));

        // Save the image to the server
        String imageUrl = saveImage(postCommand.imageBase64());

        // Create a new Post object
        Post post = Post.builder()
            .title(postCommand.title())
            .content(postCommand.content())
            .imageUrl(imageUrl)
            .createdAt(new Date())
            .author(author)
            .build();

        Post savedPost = postRepository.save(post);

        PostDto postDto = PostDto.builder()
            .id(savedPost.id())
            .title(savedPost.title())
            .content(savedPost.content())
            .imageUrl(savedPost.imageUrl())
            .createdAt(savedPost.createdAt())
            .editedAt(savedPost.editedAt())
            .authorId(savedPost.author().id())
            .build();

        return postDto;
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
