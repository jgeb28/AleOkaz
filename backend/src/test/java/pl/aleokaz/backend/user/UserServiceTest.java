package pl.aleokaz.backend.user;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Spy;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.test.util.ReflectionTestUtils;

import pl.aleokaz.backend.image.ImageService;
import pl.aleokaz.backend.mail.MailingService;
import pl.aleokaz.backend.security.JwtTokenProvider;
import pl.aleokaz.backend.security.VerificationRepository;
import pl.aleokaz.backend.user.exceptions.UserExistsException;

import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

@ExtendWith(MockitoExtension.class)
public class UserServiceTest {
    @InjectMocks
    private UserService userService;

    @Mock
    private UserRepository userRepository;

    @Mock
    private VerificationRepository verificationRepository;

    @Spy
    private JwtTokenProvider jwtTokenProvider;

    @Mock
    private ImageService imageService;

    @Mock
    private MailingService mailingService;

    
    private String defaultProfilePicture = "defaultProfilePicture.png";

    @BeforeEach
    public void setUp() {
        ReflectionTestUtils.setField(userService, "defaultProfilePicture", defaultProfilePicture);
        ReflectionTestUtils.setField(userService, "mailingService", mailingService);
    }

    @Test
    public void shouldRegisterUser() throws Exception {
        final Set<UserRole> roles = new HashSet<>();
        roles.add(UserRole.UNVERIFIED_USER);

        User saved = new User(UUID.randomUUID(), "user", "", roles, "defaultProfilePicture");
        when(userRepository.save(
                argThat(user -> user.username().equals("user"))))
                .thenReturn(saved);

        final var actual = userService.registerUser("user", "".toCharArray());

        final var expected = saved.asUserDTO(); 
        assertEquals(expected, actual.asUserDTO());

        verify(verificationRepository).save(
                argThat(verification -> verification.user().equals(saved)));
    }

    @Test
    public void shouldNotRegisterUserWhenUsernameIsAlreadyUsed() throws Exception {
        final Set<UserRole> roles = new HashSet<>();
        roles.add(UserRole.UNVERIFIED_USER);

        when(userRepository.existsByUsername("user"))
                .thenReturn(true);

        assertThrows(UserExistsException.class, () -> userService.registerUser("user", "".toCharArray()));
    }
}
