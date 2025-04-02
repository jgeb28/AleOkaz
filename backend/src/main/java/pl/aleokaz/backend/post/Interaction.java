package pl.aleokaz.backend.post;

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
    @NonNull
    private User author;

    @OneToMany(mappedBy = "interaction", cascade = CascadeType.ALL)
    @NonNull
    private Set<Reaction> reactions;

    public Interaction(
            UUID id,
            @NonNull String content,
            @NonNull Date createdAt,
            Date editedAt,
            @NonNull User author,
            Set<Reaction> reactions) {
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
    }
}
