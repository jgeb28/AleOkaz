package pl.aleokaz.backend.comment;

import pl.aleokaz.backend.interaction.Interaction;
import pl.aleokaz.backend.reaction.Reaction;
import pl.aleokaz.backend.reaction.ReactionsDTO;
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
public class Comment extends Interaction {
    @NonNull
    @ManyToOne(optional = false)
    @EqualsAndHashCode.Exclude
    @ToString.Exclude
    private Interaction parent;

    @Builder
    public Comment(
            UUID id,
            @NonNull Interaction parent,
            @NonNull String content,
            @NonNull Date createdAt,
            Date editedAt,
            User author,
            Set<Reaction> reactions,
            Set<Comment> comments) {
        super(id, content, createdAt, editedAt, author, reactions, comments);
        this.parent = parent;
    }

    public CommentDTO asCommentDto() {
        Set<CommentDTO> commentsDtos = new HashSet<CommentDTO>();
        for (Comment subcomment : comments()) {
            commentsDtos.add(subcomment.asCommentDto());
        }

        ReactionsDTO reactionsDto = new ReactionsDTO();

        for (Reaction reaction : reactions()) {
            if (reaction.author().equals(author())) {
                reactionsDto.userReaction(reaction.type());
            }

            switch (reaction.type()) {
                case LIKE -> reactionsDto.likes(reactionsDto.likes() + 1);
                case HEART -> reactionsDto.hearts(reactionsDto.hearts() + 1);
                case LAUGH -> reactionsDto.laughs(reactionsDto.laughs() + 1);
                case WOW -> reactionsDto.wows(reactionsDto.wows() + 1);
                case FISH -> reactionsDto.fish(reactionsDto.fish() + 1);
            }
        }

        return CommentDTO.builder()
                .id(id())
                .content(content())
                .createdAt(createdAt())
                .editedAt(editedAt())
                .authorId(author().id())
                .reactions(reactionsDto)
                .comments(commentsDtos)
                .build();
    }
}
