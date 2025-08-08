package pl.aleokaz.backend.friends;

import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.concurrent.CompletableFuture;

import static org.assertj.core.api.Assertions.assertThat;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import static org.mockito.ArgumentMatchers.any;
import org.mockito.InjectMocks;
import org.mockito.Mock;

import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import org.mockito.junit.jupiter.MockitoExtension;
import org.mockito.junit.jupiter.MockitoSettings;
import org.mockito.quality.Strictness;
import org.springframework.kafka.core.KafkaTemplate;

import pl.aleokaz.backend.friends.exceptions.FriendRequestNotFoundException;
import pl.aleokaz.backend.friends.exceptions.FriendshipNotFoundException;
import pl.aleokaz.backend.user.User;
import pl.aleokaz.backend.user.UserRole;
import pl.aleokaz.backend.user.UserService;

@ExtendWith(MockitoExtension.class)
@MockitoSettings(strictness = Strictness.LENIENT)
class FriendsServiceTest {
    @Mock
    private UserService userService;

    @Mock
    private FriendshipRepository friendshipRepository;

    @Mock
    private FriendRequestRepository friendRequestRepository;

    @Mock
    private KafkaTemplate<String, String> kafkaTemplate;

    @InjectMocks
    private FriendsService friendsService;

    private User mockUser;
    private User mockSecondUser;
    private UUID userId;
    private UUID secondUserId;

    @BeforeEach
    public void setup() {
        userId = UUID.randomUUID();
        secondUserId = UUID.randomUUID();
        mockUser = new User(userId, "testUser",
                "password123", new HashSet<UserRole>(), "pictureUrl");
        mockSecondUser = new User(secondUserId, "friendUser",
                "password123", new HashSet<UserRole>(), "pictureUrl");

        when(userService.getUserById(userId)).thenReturn(mockUser);
        when(userService.getUserByUsername("testUser")).thenReturn(mockUser);
        when(userService.getUserById(secondUserId)).thenReturn(mockSecondUser);
        when(userService.getUserByUsername("friendUser")).thenReturn(mockSecondUser);

        when(kafkaTemplate.send(any(String.class), any(String.class)))
                .thenReturn(CompletableFuture.completedFuture(null));
    }

    @Test
    public void shouldSendFriendRequestWhenFriendshipDoesNotExist() {
        when(friendRequestRepository.existsBySenderIdAndReceiverId(userId, secondUserId)).thenReturn(false);
        when(friendshipRepository.existsByUserIdAndFriendId(userId, secondUserId)).thenReturn(false);
        when(friendRequestRepository.save(any(FriendRequest.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));

        FriendRequest request = friendsService.sendFriendRequest(userId, secondUserId);

        assertThat(request).isNotNull();
        assertThat(request.sender()).isEqualTo(mockUser);
        assertThat(request.receiver()).isEqualTo(mockSecondUser);
        verify(friendRequestRepository).save(any(FriendRequest.class));
    }

    @Test
    public void shouldNotSendFriendRequestWhenSameUser() {
        when(friendRequestRepository.existsBySenderIdAndReceiverId(userId, userId)).thenReturn(false);
        when(friendshipRepository.existsByUserIdAndFriendId(userId, userId)).thenReturn(false);

        try {
            friendsService.sendFriendRequest(userId, userId);
        } catch (IllegalArgumentException e) {
            assertThat(e.getMessage()).isEqualTo("You cannot send a friend request to yourself.");
        }
        verify(friendRequestRepository, never()).save(any(FriendRequest.class));
    }

    @Test
    public void shouldThrowWhenFriendRequestAlreadyExists() {
        when(friendRequestRepository.existsBySenderIdAndReceiverId(userId, secondUserId)).thenReturn(true);
        try {
            friendsService.sendFriendRequest(userId, secondUserId);
        } catch (IllegalArgumentException e) {
            assertThat(e.getMessage()).isEqualTo("Friend request already sent.");
        }
        verify(friendRequestRepository, never()).save(any(FriendRequest.class));
    }

    @Test
    public void shouldThrowWhenFriendshipAlreadyExists() {
        when(friendshipRepository.existsByUserIdAndFriendId(userId, secondUserId)).thenReturn(true);
        try {
            friendsService.sendFriendRequest(userId, secondUserId);
        } catch (IllegalArgumentException e) {
            assertThat(e.getMessage()).isEqualTo("Friendship already exists.");
        }
        verify(friendRequestRepository, never()).save(any(FriendRequest.class));
    }

    @Test
    void shouldCancelFriendRequestWhenExists() {
        when(friendRequestRepository.findAllByReceiverIdAndSenderId(secondUserId, userId))
                .thenReturn(List.of(new FriendRequest(mockUser, mockSecondUser)));

        friendsService.cancelFriendRequest(userId, secondUserId);

        verify(friendRequestRepository).delete(any(FriendRequest.class));
    }

    @Test
    public void shouldThrowWhenCancelingNonExistentFriendRequest() {
        when(friendRequestRepository.findAllByReceiverIdAndSenderId(secondUserId, userId))
                .thenReturn(List.of());
        try {
            friendsService.cancelFriendRequest(userId, secondUserId);
        } catch (FriendRequestNotFoundException e) {
            assertThat(e.getMessage()).isEqualTo("Friend request with field receiver_id and value " + secondUserId.toString() + " doesn't exist.");
        }
        verify(friendRequestRepository, never()).delete(any(FriendRequest.class));
    }


    @Test
    public void shouldAcceptFriendRequestWhenExists() {
        when(friendRequestRepository.findAllByReceiverIdAndSenderId(secondUserId, userId))
                .thenReturn(List.of(new FriendRequest(mockUser, mockSecondUser)));
        when(friendshipRepository.save(any(Friendship.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));

        Friendship friendship = friendsService.acceptFriendRequest(userId, secondUserId);

        assertThat(friendship).isNotNull();
        assertThat(friendship.user()).isEqualTo(mockUser);
        assertThat(friendship.friend()).isEqualTo(mockSecondUser);
        verify(friendRequestRepository).delete(any(FriendRequest.class));
        verify(friendshipRepository).save(any(Friendship.class));
    }

    @Test
    public void shouldThrowWhenAcceptingNonExistentFriendRequest() {
        when(friendRequestRepository.findAllByReceiverIdAndSenderId(userId, secondUserId))
                .thenReturn(List.of());
        try {
            friendsService.acceptFriendRequest(secondUserId, userId);
        } catch (FriendRequestNotFoundException e) {
            assertThat(e.getMessage()).isEqualTo("Friend request with field sender_id and value " + secondUserId.toString() + " doesn't exist.");
        }
        verify(friendRequestRepository, never()).delete(any(FriendRequest.class));
        verify(friendshipRepository, never()).save(any(Friendship.class));
    }

    @Test
    public void shouldDenyFriendRequestWhenExists() {
        when(friendRequestRepository.findAllByReceiverIdAndSenderId(secondUserId, userId))
                .thenReturn(List.of(new FriendRequest(mockSecondUser, mockUser)));

        friendsService.denyFriendRequest(userId, secondUserId);

        verify(friendRequestRepository).delete(any(FriendRequest.class));
    }
    
    @Test
    public void shouldThrowWhenDenyingNonExistentFriendRequest() {
        when(friendRequestRepository.findAllByReceiverIdAndSenderId(userId, secondUserId))
                .thenReturn(List.of());
        try {
            friendsService.denyFriendRequest(secondUserId, userId);
        } catch (FriendRequestNotFoundException e) {
            assertThat(e.getMessage()).isEqualTo("Friend request with field sender_id and value " + secondUserId.toString() + " doesn't exist.");
        }
        verify(friendRequestRepository, never()).delete(any(FriendRequest.class));
        verify(friendshipRepository, never()).save(any(Friendship.class));
    }


    @Test
    public void shouldRemoveFriendWhenFriendshipExists() {
        Friendship friendship = new Friendship(mockUser, mockSecondUser);
        when(friendshipRepository.findSymmetricalFriendship(userId, secondUserId)).thenReturn(Optional.of(friendship));

        friendsService.removeFriend(userId, secondUserId);

        verify(friendshipRepository).delete(friendship);
    }

    @Test
    public void shouldThrowWhenRemovingNonExistentFriend() {
        when(friendshipRepository.findSymmetricalFriendship(userId, secondUserId)).thenReturn(Optional.empty());
        try {
            friendsService.removeFriend(userId, secondUserId);
        } catch (FriendshipNotFoundException e) {
            assertThat(e.getMessage()).isEqualTo("Friendship with field friend_id and value " + secondUserId.toString() + " doesn't exist.");
        }
        verify(friendshipRepository, never()).delete(any(Friendship.class));
    }
}