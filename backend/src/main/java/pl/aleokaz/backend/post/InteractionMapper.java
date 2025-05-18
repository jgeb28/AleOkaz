package pl.aleokaz.backend.post;

import org.springframework.beans.factory.annotation.Autowired;
import pl.aleokaz.backend.fishingspot.FishingSpotMapper;
import pl.aleokaz.backend.user.User;

import java.util.HashSet;
import java.util.Set;

import org.springframework.stereotype.Service;

import lombok.NonNull;

@Service
public class InteractionMapper {
    @Autowired
    FishingSpotMapper fishingSpotMapper;

    public PostDto convertPostToPostDto(@NonNull Post post, User user) {
        final var comments = new HashSet<CommentDto>();
        for (final var subcomment : post.comments()) {
            comments.add(convertCommentToCommentDto(subcomment, user));
        }

        return PostDto.builder()
                .id(post.id())
                .content(post.content())
                .imageUrl(post.imageUrl())
                .createdAt(post.createdAt())
                .editedAt(post.editedAt())
                .authorId(post.author().id())
                .reactions(convertReactionsToReactionsDto(post.reactions(), user))
                .comments(comments)
                .fishingSpot(fishingSpotMapper.convertFishingSpotToFishingSpotDto(post.fishingSpot()))
                .build();
    }

    public CommentDto convertCommentToCommentDto(Comment comment, User user) {
        final var subcomments = new HashSet<CommentDto>();
        for (final var subcomment : comment.comments()) {
            subcomments.add(convertCommentToCommentDto(subcomment, user));
        }

        return CommentDto.builder()
                .id(comment.id())
                .content(comment.content())
                .createdAt(comment.createdAt())
                .editedAt(comment.editedAt())
                .authorId(comment.author().id())
                .reactions(convertReactionsToReactionsDto(comment.reactions(), user))
                .comments(subcomments)
                .build();
    }

    public ReactionsDto convertReactionsToReactionsDto(Set<Reaction> reactions, User user) {
        final var result = new ReactionsDto();

        for (final var reaction : reactions) {
            if (reaction.author().equals(user)) {
                result.userReaction(reaction.type());
            }

            switch (reaction.type()) {
                case LIKE -> result.likes(result.likes() + 1);
            }
        }

        return result;
    }
}
