package pl.aleokaz.backend.user;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface UserRepository extends JpaRepository<User, UUID> {
    public boolean existsByEmail(String email);

    public boolean existsByUsername(String username);

    public User findByUsername(String username);

    public User findByEmail(String email);
}
