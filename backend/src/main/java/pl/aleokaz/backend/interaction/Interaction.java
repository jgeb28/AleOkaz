package pl.aleokaz.backend.interaction;

import pl.aleokaz.backend.comment.Comment;
import pl.aleokaz.backend.reaction.Reaction;
import pl.aleokaz.backend.user.User;

import jakarta.persistence.CascadeType;
import jakarta.persistence.DiscriminatorColumn;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Inheritance;
import jakarta.persistence.InheritanceType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.NonNull;

import java.util.Date;
import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

@Data
@Entity
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
@DiscriminatorColumn(name = "type")
@NoArgsConstructor
public abstract class Interaction {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @NonNull
    private String content;

    @NonNull
    private Date createdAt;

    private Date editedAt;

    @ManyToOne
    @JoinColumn(name = "author_id", nullable = false)
    private User author;

    @OneToMany(mappedBy = "interaction", cascade = CascadeType.ALL, orphanRemoval = true)
    @NonNull
    private Set<Reaction> reactions;

    @OneToMany(mappedBy = "parent", cascade = CascadeType.ALL, orphanRemoval = true)
    @NonNull
    private Set<Comment> comments;

    public Interaction(
            UUID id,
            @NonNull String content,
            @NonNull Date createdAt,
            Date editedAt,
            User author,
            Set<Reaction> reactions,
            Set<Comment> comments) {
        this.id = id;
        this.content = content;
        this.createdAt = createdAt;
        this.editedAt = editedAt;
        this.author = author;

        if (reactions == null) {
            this.reactions = new HashSet<>();
        } else {
            this.reactions = new HashSet<>(reactions);
        }

        if (comments == null) {
            this.comments = new HashSet<>();
        } else {
            this.comments = new HashSet<>(comments);
        }
    }
}
