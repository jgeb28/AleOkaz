package pl.aleokaz.backend.user;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface VerificationRepository extends JpaRepository<Verification, UUID> {
}
