package pl.aleokaz.backend.post;

import pl.aleokaz.backend.comment.Comment;
import pl.aleokaz.backend.comment.CommentDTO;
import pl.aleokaz.backend.fishingspot.FishingSpot;
import pl.aleokaz.backend.interaction.Interaction;
import pl.aleokaz.backend.reaction.Reaction;
import pl.aleokaz.backend.reaction.ReactionService;
import pl.aleokaz.backend.user.User;

import jakarta.persistence.*;
import lombok.*;

import java.util.Date;
import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

@Entity
@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
public class Post extends Interaction {
    @NonNull
    private String imageUrl;

    @NonNull
    @ManyToOne
    @JoinColumn(name = "fishing_spot_id", nullable = false)
    private FishingSpot fishingSpot;

    @Builder
    public Post(
            UUID id,
            String content,
            String imageUrl,
            Date createdAt,
            Date editedAt,
            User author,
            Set<Reaction> reactions,
            Set<Comment> comments,
            FishingSpot fishingSpot) {
        super(id, content, createdAt, editedAt, author, reactions, comments);
        this.imageUrl = imageUrl;
        this.fishingSpot = fishingSpot;
    }

    public PostDTO asPostDTO() {
        final var comments = new HashSet<CommentDTO>();
        for (final var subcomment : comments()) {
            comments.add(subcomment.asCommentDto());
        }

        return PostDTO.builder()
                .id(id())
                .content(content())
                .imageUrl(imageUrl)
                .createdAt(createdAt())
                .editedAt(editedAt())
                .authorId(author().id())
                .fishingSpotId(fishingSpot.id())
                .reactions(ReactionService.reactionsAsReactionsDto(reactions(), author()))
                .comments(comments)
                .build();
    }
}
