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

    @Column(name = "is_active")
    private boolean isActive;

    public UUID getFriendId(UUID currentUserId) {
        return user().id().equals(currentUserId) ? friend().id() : user().id();
    }

    //TODO(marcin): Jak będą zdjęcia użytkowników to dodać
    public FriendDTO toFriendDTO(UUID currentUserId){
        return user().id().equals(currentUserId) ? 
            FriendDTO.builder().username(friend().username()).avatar_url("avatar_url").is_accepted(isActive()).is_sender(true).build() :
            FriendDTO.builder().username(user().username()).avatar_url("avatar_url").is_accepted(isActive()).is_sender(false).build();
    }

    public Friendship(User user, User friend, boolean isActive) {
        this.user = user;
        this.friend = friend;
        this.isActive = isActive;
    }
}