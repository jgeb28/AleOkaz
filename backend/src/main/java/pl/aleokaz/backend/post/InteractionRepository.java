package pl.aleokaz.backend.post;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface InteractionRepository extends JpaRepository<Interaction, UUID> {
}
