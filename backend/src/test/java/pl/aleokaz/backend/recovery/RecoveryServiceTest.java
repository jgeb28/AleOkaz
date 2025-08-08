package pl.aleokaz.backend.recovery;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.UUID;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.mockito.junit.jupiter.MockitoSettings;
import org.mockito.quality.Strictness;
import org.springframework.test.util.ReflectionTestUtils;

import pl.aleokaz.backend.mail.MailingService;
import pl.aleokaz.backend.recovery.commands.ResetPasswordCommand;
import pl.aleokaz.backend.user.User;
import pl.aleokaz.backend.user.UserRole;
import pl.aleokaz.backend.user.UserService;


@ExtendWith(MockitoExtension.class)
@MockitoSettings(strictness = Strictness.LENIENT)
public class RecoveryServiceTest {
    @Mock
    private TokenRepository tokenRepository;

    @Mock
    private UserService userService;

    @Mock
    private MailingService mailingService;

    @InjectMocks
    private RecoveryService recoveryService;

    private User mockUser;
    private UUID userId;
    private String token;
    private RecoveryToken recoveryToken;

/*     @BeforeEach
    public void setup() {
        ReflectionTestUtils.setField(recoveryService, "tokenAttempts", 5);
        ReflectionTestUtils.setField(recoveryService, "tokenExpirationMinutes", 60);

        token = UUID.randomUUID().toString();
        userId = UUID.randomUUID();
        mockUser = new User(userId, "user@mail.com", "testUser",
                "password123", new HashSet<UserRole>(), "pictureUrl");
        recoveryToken = RecoveryToken.builder()
                .user(mockUser)
                .token(token)
                .expirationDate(LocalDateTime.of(2100, 1, 1, 0, 0, 0))
                .build();

        when(userService.getUserById(userId)).thenReturn(mockUser);
        when(userService.getUserByUsername("testUser")).thenReturn(mockUser);
        when(userService.getUserByEmail("user@mail.com")).thenReturn(mockUser);
        doNothing().when(tokenRepository).delete(any(RecoveryToken.class));
        when(tokenRepository.save(any(RecoveryToken.class)))
                .thenAnswer(invocation -> invocation.getArgument(0));
    }

    @Test
    public void shouldCreateAndSendRecoveryTokenWhenNoneExists() {
        when(tokenRepository.findByUserId(userId))
                .thenReturn(null);
        recoveryService.createAndSendRecoveryToken("user@mail.com");
        verify(mailingService)
                .sendEmail(eq("user@mail.com"),eq("Recovery token"),anyString());
    }

    @Test
    public void shouldDeleteOldTokenAndCreateNewWhenAnotherTokenExists() {
        when(tokenRepository.findByUserId(userId))
                .thenReturn(recoveryToken);
        recoveryService.createAndSendRecoveryToken("user@mail.com");
        verify(mailingService)
                .sendEmail(eq("user@mail.com"),eq("Recovery token"),anyString());
        verify(tokenRepository).delete(any(RecoveryToken.class));
    }

    @Test
    public void shouldVerifyTokenAsCorrectWhenExists() {
        when(tokenRepository.findByUserId(userId)).thenReturn(recoveryToken);
        boolean isValid = recoveryService.isTokenCorrect("user@mail.com", token);
        assertThat(isValid).isTrue();
    }

    @Test
    public void shouldNotVerifyTokenWhenIncorrect() {
        when(tokenRepository.findByUserId(userId)).thenReturn(recoveryToken);
        boolean isValid = recoveryService.isTokenCorrect("user@mail.com", "wrongToken");
        assertThat(isValid).isFalse();
    }

    @Test
    public void shouldNotVerifyTokenWhenExpired() {
        recoveryToken.expirationDate(LocalDateTime.now().minusMinutes(1));
        when(tokenRepository.findByUserId(userId)).thenReturn(recoveryToken);
        boolean isValid = recoveryService.isTokenCorrect("user@mail.com", token);
        assertThat(isValid).isFalse();
    }

    @Test
    public void shouldNotVerifyTokenWhenAttemptsExceeded() {
        recoveryToken.attempts(5);
        when(tokenRepository.findByUserId(userId)).thenReturn(recoveryToken);
        boolean isValid = recoveryService.isTokenCorrect("user@mail.com", token);
        assertThat(isValid).isFalse();
    }

    @Test
    public void shouldResetPasswordWhenTokenIsCorrect() {
        ResetPasswordCommand resetPasswordCommand = ResetPasswordCommand.builder()
                .email("user@mail.com")
                .token(token)
                .password("newPassword123")
                .build();
        when(tokenRepository.findByUserId(userId)).thenReturn(recoveryToken);
        recoveryService.resetPassword(resetPasswordCommand);
        verify(userService).setUserPassword(mockUser, "newPassword123");
    } */
}
