package pl.aleokaz.backend.friends;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import static org.mockito.ArgumentMatchers.any;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import org.mockito.junit.jupiter.MockitoExtension;
import org.mockito.junit.jupiter.MockitoSettings;
import org.mockito.quality.Strictness;

import pl.aleokaz.backend.exceptions.UserNotFoundException;
import pl.aleokaz.backend.user.User;
import pl.aleokaz.backend.user.UserRepository;

@ExtendWith(MockitoExtension.class)
@MockitoSettings(strictness = Strictness.LENIENT)
class FriendsServiceTest {

    @Mock
    private UserRepository userRepository;

    @Mock
    private FriendshipRepository friendshipRepository;

    @InjectMocks
    private FriendsService friendsService;

    private User mockUser;
    private User mockFriend;
    private UUID userId;
    private UUID friendId;

    @BeforeEach
    void setup() {
        userId = UUID.randomUUID();
        friendId = UUID.randomUUID();
        mockUser = mock(User.class);
        mockFriend = mock(User.class);

        when(userRepository.getReferenceById(userId)).thenReturn(mockUser);
        when(userRepository.getReferenceById(friendId)).thenReturn(mockFriend);
        when(userRepository.findByUsername("someFriend")).thenReturn(mockFriend);
        when(userRepository.findByUsername("myself")).thenReturn(mockUser);
        when(mockUser.id()).thenReturn(userId);
        when(mockFriend.id()).thenReturn(friendId);  
    }

    @Test
    void shouldAddFriendWhenFriendshipDoesNotExist() throws UserNotFoundException {
        when(friendshipRepository.findSymmetricalFriendship(mockUser.id(), mockFriend.id())).thenReturn(Optional.empty());

        FriendCommand friendCommand = new FriendCommand(null, "someFriend");
        var result = friendsService.addFriend(friendCommand, userId);

        assertThat(result).isEqualTo(FriendsService.FriendStatus.SENT_FRIEND_REQUEST);
        verify(friendshipRepository).save(any(Friendship.class));
    }

        @Test
    void shouldNotAddFriendWhenSameUser() throws UserNotFoundException {
        FriendCommand friendCommand = new FriendCommand(null, "myself");
        var result = friendsService.addFriend(friendCommand, userId);

        assertThat(result).isEqualTo(FriendsService.FriendStatus.TRIED_TO_ADD_YOURSELF);
        verify(friendshipRepository, never()).save(any(Friendship.class));
    }

    @Test
    void shouldRemoveFriendWhenFriendshipExists() throws UserNotFoundException {

        var friendship = new Friendship(mockUser, mockFriend, true);
        when(friendshipRepository.findSymmetricalFriendship(mockUser.id(), mockFriend.id())).thenReturn(Optional.of(friendship));

        FriendCommand friendCommand = new FriendCommand(null, "someFriend");
        var result = friendsService.removeFriend(friendCommand, userId);

        assertThat(result).isEqualTo(FriendsService.FriendStatus.FRIEND_REMOVED);
        verify(friendshipRepository).delete(friendship);
    }
        

    @Test
    void shouldReturnNoFriendshipWhenRemovingUnknownFriend() throws UserNotFoundException {
        when(friendshipRepository.findSymmetricalFriendship(mockUser.id(), mockFriend.id())).thenReturn(Optional.empty());

        FriendCommand friendCommand = new FriendCommand(null, "someFriend");
        var result = friendsService.removeFriend(friendCommand, userId);

        assertThat(result).isEqualTo(FriendsService.FriendStatus.NO_FRIENDSHIP_TO_REMOVE);
        verify(friendshipRepository, never()).delete(any(Friendship.class));
    }

    @Test
    void shouldGetFriends() {
        when(friendshipRepository.findAllByUserId(userId)).thenReturn(List.of());
        var friends = friendsService.getFriends(userId);
        assertThat(friends).isEmpty();
    }
}