package pl.aleokaz.backend.post;

import pl.aleokaz.backend.fishingspot.FishingSpot;
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
}
