package pl.aleokaz.backend.post;

import pl.aleokaz.backend.user.User;

import jakarta.persistence.*;
import lombok.*;

import java.util.Date;
import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

@Entity
@Data
@Builder
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

    @OneToMany(mappedBy = "post", cascade = CascadeType.ALL)
    @NonNull
    private Set<PostReaction> reactions = new HashSet<>();

    @Builder
    public Post(
            UUID id,
            String content,
            String imageUrl,
            Date createdAt,
            Date editedAt,
            User author,
            Set<PostReaction> reactions) {
        this.id = id;
        this.content = content;
        this.imageUrl = imageUrl;
        this.createdAt = createdAt;
        this.editedAt = editedAt;
        this.author = author;
        this.reactions = new HashSet<>(reactions);
    }
}
