package pl.aleokaz.backend.friends;

import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;

public interface FriendRequestRepository extends JpaRepository<FriendRequest, UUID> {
    List<FriendRequest> findAllBySenderId(UUID senderId);
    List<FriendRequest> findAllByReceiverId(UUID receiverId);
    boolean existsBySenderIdAndReceiverId(UUID senderId, UUID receiverId);
    List<FriendRequest> findAllByReceiverIdAndSenderId(UUID receiverId, UUID senderId);
}
