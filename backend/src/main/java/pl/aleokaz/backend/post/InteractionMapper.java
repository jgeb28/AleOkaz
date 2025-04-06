package pl.aleokaz.backend.post;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;

import org.springframework.stereotype.Service;

@Service
public class InteractionMapper {
    public PostDto convertPostToPostDto(Post post) {
        final Map<String, Integer> reactions = new HashMap<>();
        for (final ReactionType type : ReactionType.values()) {
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
                .comments(new HashSet<>(post.comments().stream()
                        .map(this::convertPostCommentToPostCommentDto)
                        .toList()))
                .build();
    }

    public CommentDto convertPostCommentToPostCommentDto(Comment comment) {
        final Map<String, Integer> reactions = new HashMap<>();
        for (final ReactionType type : ReactionType.values()) {
            reactions.put(type.name(), 0);
        }

        for (final var reaction : comment.reactions()) {
            final var type = reaction.type().name();
            reactions.put(
                    type,
                    reactions.get(type) + 1);
        }

        return CommentDto.builder()
                .id(comment.id())
                .content(comment.content())
                .createdAt(comment.createdAt())
                .editedAt(comment.editedAt())
                .authorId(comment.author().id())
                .reactions(reactions)
                .comments(new HashSet<>(comment.comments().stream()
                        .map(this::convertPostCommentToPostCommentDto)
                        .toList()))
                .build();
    }
}
