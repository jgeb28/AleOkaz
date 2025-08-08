package pl.aleokaz.backend.recovery;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface TokenRepository extends JpaRepository<RecoveryToken, UUID> {
    public RecoveryToken findByUserId(UUID userId);
}
