package pl.aleokaz.backend.post;

import org.springframework.stereotype.Service;

@Service
public class PostMapper {
    public PostDto convertPostToPostDto(Post post) {
        return PostDto.builder()
            .id(post.id())
            .title(post.title())
            .content(post.content())
            .imageUrl(post.imageUrl())
            .createdAt(post.createdAt())
            .editedAt(post.editedAt())
            .authorId(post.author().id())
            .build();
    }
}
