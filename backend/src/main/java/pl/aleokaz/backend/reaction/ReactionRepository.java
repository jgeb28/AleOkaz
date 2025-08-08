package pl.aleokaz.backend.reaction;

import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

public interface ReactionRepository extends JpaRepository<Reaction, UUID> {
}
