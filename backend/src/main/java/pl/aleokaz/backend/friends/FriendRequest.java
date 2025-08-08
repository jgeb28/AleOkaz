package pl.aleokaz.backend.friends;

import java.util.UUID;

import jakarta.persistence.*;
import lombok.*;
import pl.aleokaz.backend.user.User;

@Entity
@Table(name = "user_friend_requests")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class FriendRequest {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne
    @JoinColumn(name = "sender_id")
    private User sender;

    @ManyToOne
    @JoinColumn(name = "receiver_id")
    private User receiver;

    public FriendRequest(User sender, User receiver) {
        this.sender = sender;
        this.receiver = receiver;
    }
    
    public FriendDTO toFriendDTO(UUID currentUserId) {
        boolean isSender = sender.id().equals(currentUserId);
        User other = isSender ? receiver : sender;
        return FriendDTO.builder()
                .username(other.username())
                .avatar_url(other.profilePicture())
                .build();
    }
}
