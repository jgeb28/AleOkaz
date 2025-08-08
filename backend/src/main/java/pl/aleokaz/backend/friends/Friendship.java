package pl.aleokaz.backend.friends;

import java.util.UUID;

import jakarta.persistence.*;
import lombok.*;
import pl.aleokaz.backend.user.User;

@Entity
@Table(name = "user_friends")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Friendship {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne
    @JoinColumn(name = "friend_id")
    private User friend;

    public Friendship(User user, User friend) {
        this.user = user;
        this.friend = friend;
    }
    
    public UUID getFriendId(UUID currentUserId) {
        UUID userID = user().id();
        UUID friendID = friend().id();
        return userID.equals(currentUserId) ? friendID : userID;
    }

    public FriendDTO toFriendDTO(UUID currentUserId) {
        boolean isSender = user().id().equals(currentUserId);
        User other = isSender ? friend() : user();
        return FriendDTO.builder()
                .username(other.username())
                .avatar_url(other.profilePicture())
                .build();
    }
}
