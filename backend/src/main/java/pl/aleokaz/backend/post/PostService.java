package pl.aleokaz.backend.post;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import jakarta.transaction.Transactional;
import lombok.NonNull;
import pl.aleokaz.backend.fishingspot.FishingSpot;
import pl.aleokaz.backend.fishingspot.FishingSpotService;
import pl.aleokaz.backend.image.ImageService;
import pl.aleokaz.backend.post.commands.PostCommand;
import pl.aleokaz.backend.post.exceptions.PostNotFoundException;
import pl.aleokaz.backend.security.AuthorizationException;
import pl.aleokaz.backend.user.User;
import pl.aleokaz.backend.user.UserService;

import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@Transactional
public class PostService {
    @Autowired
    private PostRepository postRepository;

    @Autowired
    private UserService userService;

    @Autowired
    private ImageService imageService;

    @Autowired
    private FishingSpotService fishingSpotService;

    public List<Post> getPostsByAuthorId(UUID authorId) {
        return postRepository.findByAuthorId(authorId);
    }

    public Post getPostByPostId(UUID postId) {
        return postRepository.findById(postId)
                .orElseThrow(() -> new PostNotFoundException("id", postId.toString()));
    }

    public List<Post> getPostsByFishingSpotId(UUID fishingSpotId, UUID userId) {
        return postRepository.findByFishingSpotId(fishingSpotId);
    }

    public List<PostDTO> postsAsPostDtos(List<Post> posts) {
        return posts.stream()
                .map(Post::asPostDTO)
                .collect(Collectors.toList());
    }

    public Post createPost(@NonNull UUID userId, PostCommand postCommand, MultipartFile image)
            throws IOException {
        User author = userService.getUserById(userId);
        FishingSpot fishingSpot = fishingSpotService.getFishingSpotById(postCommand.fishingSpotId());

        String imageUrl;
        //try {
            imageUrl = imageService.saveImage(image);
        //} catch (IOException e) {
        //    throw new ImageSaveException();
        //}

        final var post = Post.builder()
                .content(postCommand.content())
                .imageUrl(imageUrl)
                .createdAt(new Date())
                .author(author)
                .fishingSpot(fishingSpot)
                .build();

        return postRepository.save(post);
    }

    public Post updatePost(@NonNull UUID userId, UUID postId, PostCommand postCommand)
            throws AuthorizationException {
        User author = userService.getUserById(userId);
        Post post = getPostByPostId(postId);
        author.verifyAs(post.author());
        post.content(postCommand.content());
        post.editedAt(new Date());
        return postRepository.save(post);
    }

    public void deletePost(@NonNull UUID userId, UUID postId)
            throws AuthorizationException {
        User author = userService.getUserById(userId);
        Post post = getPostByPostId(postId);
        author.verifyAs(post.author());
        postRepository.delete(post);
    }
}
