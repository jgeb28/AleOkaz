package pl.aleokaz.backend.recovery;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.validation.constraints.NotNull;
import lombok.Builder;
import lombok.Data;
import pl.aleokaz.backend.user.User;

@Data
@Entity
public class RecoveryToken {
    @Id
    @NotNull
    @Column(unique = true, updatable = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotNull
    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @NotNull
    @Column(unique = true, updatable = false)
    private String token;

    @NotNull
    private LocalDateTime expirationDate;

    @Builder
    public RecoveryToken(String token, User user, LocalDateTime expirationDate) {
        this.token = token;
        this.user = user;
        this.expirationDate = expirationDate;
    }
}
