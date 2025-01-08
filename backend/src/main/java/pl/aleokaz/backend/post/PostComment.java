package pl.aleokaz.backend.post;

import jakarta.persistence.*;
import lombok.*;
import pl.aleokaz.backend.user.User;

import java.sql.Date;
import java.util.UUID;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
public class PostComment {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @NonNull
    private String title;

    @NonNull
    private String content;

    @NonNull
    private String imageUrl;

    @NonNull
    private Date createdAt;

    private Date editedAt;

    @ManyToOne
    @JoinColumn(name = "author_id")
    @NonNull
    private User author;

    @ManyToOne
    @JoinColumn(name = "post_id")
    private Post post;
}
