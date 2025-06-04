package pl.aleokaz.backend.post;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import jakarta.transaction.Transactional;
import lombok.NonNull;
import pl.aleokaz.backend.fishingspot.FishingSpot;
import pl.aleokaz.backend.fishingspot.FishingSpotRepository;
import pl.aleokaz.backend.user.User;
import pl.aleokaz.backend.user.UserRepository;
import pl.aleokaz.backend.user.AuthorizationException;

import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@Transactional
public class PostService {
    @Autowired
    private PostRepository postRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private InteractionMapper postMapper;

    @Autowired
    private ImageService imageService;
    @Autowired
    private FishingSpotRepository fishingSpotRepository;

    public PostDto createPost(@NonNull UUID userId, PostCommand postCommand, MultipartFile image)
            throws ImageSaveException {
        final var author = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Author not found"));

        final var fishingSpot = fishingSpotRepository.findById(postCommand.fishingSpotId())
            .orElseThrow(() -> new RuntimeException("FishingSpot not found"));

        String imageUrl;
        try {
            imageUrl = imageService.saveImage(image);
        } catch (IOException ioe) {
            throw new ImageSaveException();
        }

        final var post = Post.builder()
                .content(postCommand.content())
                .imageUrl(imageUrl)
                .createdAt(new Date())
                .author(author)
                .fishingSpot(fishingSpot)
                .build();

        final var savedPost = postRepository.save(post);

        return postMapper.convertPostToPostDto(savedPost, author);
    }

    public PostDto updatePost(@NonNull UUID userId, UUID postId, PostCommand postCommand)
            throws AuthorizationException {
        final var author = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Author not found"));
        final var post = postRepository.findById(postId)
                .orElseThrow(() -> new RuntimeException("Post not found"));

        if (!author.equals(post.author())) {
            throw new AuthorizationException(userId.toString());
        }

        post.content(postCommand.content());
        post.editedAt(new Date());

        final var savedPost = postRepository.save(post);

        return postMapper.convertPostToPostDto(savedPost, author);
    }

    public PostDto deletePost(@NonNull UUID userId, UUID postId) throws AuthorizationException {
        final var author = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("Author not found"));
        final var post = postRepository.findById(postId)
                .orElseThrow(() -> new RuntimeException("Post not found"));

        if (!author.equals(post.author())) {
            throw new AuthorizationException(userId.toString());
        }

        PostDto responsePost = postMapper.convertPostToPostDto(post, author);

        postRepository.delete(post);

        return responsePost;
    }

    public List<PostDto> getAllPosts(UUID userId) {
        final var user = Optional.ofNullable(userId)
                .flatMap(userRepository::findById)
                .orElse(null);
        final List<Post> posts = postRepository.findAll();

        return posts.stream()
                .map(post -> postMapper.convertPostToPostDto(post, user))
                .collect(Collectors.toList());
    }

    public List<PostDto> getPostsByUserId(UUID userId, UUID authorId) {
        final var user = Optional.ofNullable(userId)
                .flatMap(userRepository::findById)
                .orElse(null);
        final List<Post> posts = postRepository.findByAuthorId(authorId);

        return posts.stream()
                .map(post -> postMapper.convertPostToPostDto(post, user))
                .collect(Collectors.toList());
    }

    public PostDto getPostById(UUID userId, UUID postId) {
        final var user = Optional.ofNullable(userId)
                .flatMap(userRepository::findById)
                .orElse(null);
        final var post = postRepository.findById(postId)
                .orElseThrow(() -> new RuntimeException("Post not found"));

        return postMapper.convertPostToPostDto(post, user);
    }
}
