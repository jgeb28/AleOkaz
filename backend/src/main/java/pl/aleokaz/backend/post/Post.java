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
public class Post extends Interaction {
    @NonNull
    private String imageUrl;

    @Builder
    public Post(
            UUID id,
            String content,
            String imageUrl,
            Date createdAt,
            Date editedAt,
            User author,
            Set<Reaction> reactions,
            Set<PostComment> comments) {
        super(id, content, createdAt, editedAt, author, reactions, comments);
        this.imageUrl = imageUrl;
    }
}
