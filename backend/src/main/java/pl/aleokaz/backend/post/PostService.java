package pl.aleokaz.backend.post;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import jakarta.transaction.Transactional;
import lombok.NonNull;
import pl.aleokaz.backend.user.User;
import pl.aleokaz.backend.user.UserRepository;
import pl.aleokaz.backend.user.AuthorizationException;

import java.io.IOException;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
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
    private PostMapper postMapper;

    @Autowired
    private ImageService imageService;

    public PostDto createPost(UUID userId, PostCommand postCommand, MultipartFile image) throws PostSaveException {
        User author = userRepository.findById(userId)
            .orElseThrow(() -> new RuntimeException("Author not found"));

        String imageUrl;
        try {
            imageUrl = imageService.saveImage(image);
        } catch (IOException ioe) {
            throw new PostSaveException();
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

        if(!userId.equals(post.author().id())) {
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

    public void setPostReaction(
            @NonNull UUID postId,
            @NonNull UUID userId,
            @NonNull PostReactionType reactionType) {
        final var author = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        final var post = postRepository.findById(postId)
                .orElseThrow(() -> new RuntimeException("Post not found"));

        final Set<PostReaction> reactions = new HashSet<>(post.reactions());
        reactions.removeIf(reaction -> reaction.author().id().equals(userId));
        reactions.add(PostReaction.builder()
                .type(reactionType)
                .author(author)
                .post(post)
                .build());

        post.reactions(reactions);

        postRepository.save(post);
    }

    public void deletePostReaction(@NonNull UUID postId, @NonNull UUID userId) {
        if (!userRepository.existsById(userId)) {
            throw new RuntimeException("User not found");
        }

        final var post = postRepository.findById(postId)
                .orElseThrow(() -> new RuntimeException("Post not found"));

        final Set<PostReaction> reactions = post.reactions();
        reactions.removeIf(reaction -> reaction.author().id().equals(userId));

        postRepository.save(post);
    }
}
