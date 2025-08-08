package pl.aleokaz.backend.security;

import lombok.Builder;
import lombok.Data;
import lombok.NonNull;
import pl.aleokaz.backend.user.User;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.ManyToOne;

import java.time.LocalDateTime;
import java.util.UUID;

@Data
@Entity
public class Verification {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @NonNull
    @ManyToOne
    private User user;

    @NonNull
    private String code;

    @NonNull
    @Column(updatable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(insertable = false)
    private LocalDateTime verifiedAt;

    @Builder
    public Verification(UUID id, User user, String code) {
        this.id = id;
        this.user = user;
        this.code = code;
    }
}
