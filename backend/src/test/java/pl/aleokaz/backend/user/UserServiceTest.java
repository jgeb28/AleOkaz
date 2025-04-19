package pl.aleokaz.backend.user;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Spy;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.beans.factory.annotation.Value;

import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

@ExtendWith(MockitoExtension.class)
public class UserServiceTest {
    @InjectMocks
    private UserService userService;

    @Spy
    private UserMapper userMapper;

    @Mock
    private UserRepository userRepository;

    @Mock
    private VerificationRepository verificationRepository;

    @Spy
    private JwtTokenProvider jwtTokenProvider;

    @Value("${aleokaz.profile.picture.default}")
    private String defaultProfilePicture;

    @Test
    public void shouldRegisterUser() throws Exception {
        final Set<UserRole> roles = new HashSet<>();
        roles.add(UserRole.UNVERIFIED_USER);

        final var saved = new User(UUID.randomUUID(), "user@example.com", "user", "", roles, defaultProfilePicture);
        when(userRepository.save(
                argThat(user -> user.username().equals("user") &&
                        user.email().equals("user@example.com"))))
                .thenReturn(saved);

        final var registerCommand = RegisterCommand.builder()
                .username("user")
                .email("user@example.com")
                .password("".toCharArray())
                .build();

        final var actual = userService.registerUser(registerCommand);

        final var expected = userMapper.convertUserToUserDto(saved);
        assertEquals(expected, actual);

        verify(verificationRepository).save(
                argThat(verification -> verification.user().equals(saved)));
    }

    @Test
    public void shouldNotRegisterUserWhenUsernameIsAlreadyUsed() throws Exception {
        final Set<UserRole> roles = new HashSet<>();
        roles.add(UserRole.UNVERIFIED_USER);

        when(userRepository.existsByUsername("user"))
                .thenReturn(true);

        final var registerCommand = RegisterCommand.builder()
                .username("user")
                .email("user@example.com")
                .password("".toCharArray())
                .build();

        assertThrows(UserExistsException.class, () -> userService.registerUser(registerCommand));
    }

    @Test
    public void shouldNotRegisterUserWhenEmailIsAlreadyUsed() throws Exception {
        final Set<UserRole> roles = new HashSet<>();
        roles.add(UserRole.UNVERIFIED_USER);

        when(userRepository.existsByEmail("user@example.com"))
                .thenReturn(true);

        final var registerCommand = RegisterCommand.builder()
                .username("user")
                .email("user@example.com")
                .password("".toCharArray())
                .build();

        assertThrows(UserExistsException.class, () -> userService.registerUser(registerCommand));
    }
}
