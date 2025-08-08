package pl.aleokaz.backend.user;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.NonNull;

import org.hibernate.validator.constraints.UniqueElements;

import jakarta.persistence.CascadeType;
import jakarta.persistence.CollectionTable;
import jakarta.persistence.Column;
import jakarta.persistence.ElementCollection;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import pl.aleokaz.backend.post.Post;
import pl.aleokaz.backend.security.AuthorizationException;

import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.UUID;

@Data
@NoArgsConstructor
@Entity
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @NonNull
    @Column(unique = true)
    private String username;

    @NonNull
    private String password;

    @NonNull
    @ElementCollection
    @Enumerated(EnumType.STRING)
    @UniqueElements
    @CollectionTable(name = "user_role")
    @Column(name = "role")
    private Set<UserRole> roles;


    @OneToMany(mappedBy = "author", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Post> posts;

    @NonNull
    private String profilePicture;

    @Builder
    public User(
            UUID id,
            @NonNull String username,
            @NonNull String password,
            @NonNull Set<UserRole> roles,
            @NonNull String profilePicture) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.roles = new HashSet<>(roles);
        this.profilePicture = profilePicture;
    }

    public void verifyAs(User user) {
        if (!this.id.equals(user.id)) {
            throw new AuthorizationException(id().toString());
        }
    }

    public UserDTO asUserDTO() {
        return UserDTO.builder()
                .id(id)
                .username(username)
                .profilePicture(profilePicture)
                .build();
    }
}
