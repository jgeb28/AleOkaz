package pl.aleokaz.backend.post;

import pl.aleokaz.backend.user.User;

import jakarta.persistence.*;
import lombok.*;

import java.util.Date;
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
            @NonNull User author,
            Set<Reaction> reactions,
            Set<Comment> comments) {
        super(id, content, createdAt, editedAt, author, reactions, comments);
        this.parent = parent;
    }
}
