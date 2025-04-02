package pl.aleokaz.backend.post;

import jakarta.persistence.*;
import lombok.*;
import pl.aleokaz.backend.user.User;

import java.util.Date;
import java.util.UUID;

@Entity
@Data
@NoArgsConstructor
public class Post {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @NonNull
    private String content;

    @NonNull
    private String imageUrl;

    @NonNull
    private Date createdAt;

    private Date editedAt;

    @ManyToOne
    @JoinColumn(name = "author_id", nullable = false)
    @NonNull
    private User author;

    //TODO shares, sharedBy, privacy, comments, fishingSpot

    @Builder
    public Post(UUID id, String content, String imageUrl, Date createdAt, Date editedAt, User author) {
        this.id = id;
        this.content = content;
        this.imageUrl = imageUrl;
        this.createdAt = createdAt;
        this.editedAt = editedAt;
        this.author = author;
    }
}
