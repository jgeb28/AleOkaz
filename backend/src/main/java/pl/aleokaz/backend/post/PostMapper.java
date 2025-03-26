package pl.aleokaz.backend.post;

import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Service;

@Service
public class PostMapper {
    public PostDto convertPostToPostDto(Post post) {
        final Map<String, Integer> reactions = new HashMap<>();
        for (final PostReactionType type : PostReactionType.values()) {
            reactions.put(type.name(), 0);
        }

        for (final var reaction : post.reactions()) {
            final var type = reaction.type().name();
            reactions.put(
                    type,
                    reactions.get(type) + 1);
        }

        return PostDto.builder()
                .id(post.id())
                .content(post.content())
                .imageUrl(post.imageUrl())
                .createdAt(post.createdAt())
                .editedAt(post.editedAt())
                .authorId(post.author().id())
                .reactions(reactions)
                .build();
    }
}
