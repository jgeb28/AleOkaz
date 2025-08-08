package pl.aleokaz.backend.friends;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface FriendshipRepository extends JpaRepository<Friendship, UUID> {
    @Query(value = """
                    SELECT f
                    FROM Friendship f
                    WHERE (f.user.id = :userId AND f.friend.id = :friendId)
                    OR (f.user.id = :friendId AND f.friend.id = :userId)
            """)
    Optional<Friendship> findSymmetricalFriendship(@Param("userId") UUID userId,
            @Param("friendId") UUID friendId);

    @Query(value = """
                    SELECT f 
                    FROM Friendship f 
                    WHERE f.user.id = :userId 
                    OR f.friend.id = :userId
            """)
    List<Friendship> findAllByUserId(@Param("userId") UUID userId);
    boolean existsByUserIdAndFriendId(UUID userId, UUID friendId);
}
