package pl.aleokaz.backend.post;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface PostCommentRepository extends JpaRepository<PostComment, UUID> {
}
