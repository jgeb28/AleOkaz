package pl.aleokaz.backend.user;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.crypto.factory.PasswordEncoderFactories;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.NonNull;

import java.security.SecureRandom;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Optional;
import java.util.UUID;

@Service
@Transactional
public class UserService {
    final static Logger LOGGER = LoggerFactory.getLogger(UserService.class);

    private UserMapper userMapper;

    private UserRepository userRepository;

    private VerificationRepository verificationRepository;

    private JwtTokenProvider jwtTokenProvider;

    public UserService(@NonNull UserMapper userMapper,
            @NonNull UserRepository userRepository,
            @NonNull VerificationRepository verificationRepository,
                       @NonNull JwtTokenProvider jwtTokenProvider) {
        this.userMapper = userMapper;
        this.userRepository = userRepository;
        this.verificationRepository = verificationRepository;
        this.jwtTokenProvider = jwtTokenProvider;
    }

    /**
     * Zwraca użytkownika na podstawie id.
     *
     * @param id ID użytkownika
     * @return Użytkownika
     * @throws UserNotFoundException jeżeli użytkownik nie istnieje.
     */
    // TODO(michalciechan): Kto powinien mieć dostęp? Może ograniczony zestaw
    // danych publicznie, a dla znajomych więcej?
    public UserDto findUserById(@NonNull UUID id) {
        final var user = userRepository.findById(id)
                .orElseThrow(() -> new UserNotFoundException(id));

        return userMapper.convertUserToUserDto(user);
    }

    /**
     * Rejestruje użytkownika i wysyła kod weryfikacyjny na podanego emaila.
     * Po rejestracji użytkownik jest niezweryfikowany i nie może korzystać w pełni
     * z serwisu. Ta metoda nie autentykuje użytkownika, więc po rejestracji należy
     * zalogować użytkownika.
     *
     * @param registerCommand Dane użytkownika do zarejestrowania.
     * @return Zarejestrowanego użytkownika
     * @throws UserAlreadyExistsException jeżeli użytkownik o takiej samej nazwie
     *                                    lub emailu istnieje.
     */
    @PreAuthorize("permitAll()")
    public UserDto registerUser(@NonNull RegisterCommand registerCommand) {
        final var username = registerCommand.username();
        if (userRepository.existsByUsername(username)) {
            throw new UserExistsException("username", username);
        }

        final var email = registerCommand.email();
        if (userRepository.existsByEmail(email)) {
            // TODO(michalciechan): Zwrócić OK i wysłać emaila, że ktoś próbował
            // się zarejestrować? Na tę chwilę wyciekają informacje o tym kto ma
            // u nas konto.
            throw new UserExistsException("email", email);
        }

        // TODO(michalciechan): Minimalna entropia hasła?

        final var passwordEncoder = PasswordEncoderFactories.createDelegatingPasswordEncoder();
        final var password = registerCommand.password();
        final var encodedPassword = passwordEncoder.encode(String.valueOf(password));
        for (int i = 0; i < password.length; i++) {
            password[i] = '\0';
        }

        final var roles = new HashSet<>(Arrays.asList(UserRole.UNVERIFIED_USER));
        var user = User.builder()
                .username(username)
                .email(email)
                .password(encodedPassword)
                .roles(roles)
                .build();
        user = userRepository.save(user);

        final var code = createVerificationCode();

        final var verification = Verification.builder()
                .user(user)
                .code(code)
                .build();
        verificationRepository.save(verification);

        // TODO(michalciechan): Wysłać emaila.
        LOGGER.info("Created verification code {} for user {}",
                code,
                user.id().toString());

        return userMapper.convertUserToUserDto(user);
    }

    /**
     * Sprawdza, czy login i hasło użytkownika się zgadzają. Jeśli tak, to zwraca
     * token
     *
     * @param loginCommand Dane użytkownika do logowania.
     * @return JWT Access i Refresh tokeny i ich expiration date
     * @throws IllegalArgumentException jeżeli dane logowania są niepoprawne
     */

    @PreAuthorize("permitAll()")
    public LoginResponse loginUser(LoginCommand loginCommand) {
        var user = userRepository.findByUsername(loginCommand.username());

        final PasswordEncoder passwordEncoder = PasswordEncoderFactories.createDelegatingPasswordEncoder();
        if (user == null || !passwordEncoder.matches(loginCommand.password(), user.password())) {
            throw new IllegalArgumentException("Invalid username or password");
        }

        String accessToken = jwtTokenProvider.createAccessToken(user);
        String refreshToken = jwtTokenProvider.createRefreshToken(user);

        LoginResponse loginResponse = LoginResponse.builder()
            .accessToken(accessToken)
            .refreshToken(refreshToken)
            .build();

        return loginResponse;
    }

    @PreAuthorize("permitAll()")
    public RefreshResponse refreshUserToken(RefreshCommand refreshCommand) {
        String refreshToken = refreshCommand.refreshToken();
        UUID userId = UUID.fromString(jwtTokenProvider.getUserIdFromToken(refreshToken));
        System.out.println("user id: " + userId);

        Optional<User> optionalUser = userRepository.findById(userId);
        if (optionalUser.isPresent()) {
            User user = optionalUser.get();
            String accessToken = jwtTokenProvider.refreshAccessToken(refreshToken, user);
            System.out.println("New access token: " + accessToken);

            RefreshResponse refreshResponse = RefreshResponse.builder()
                .accessToken(accessToken)
                .build();
            return refreshResponse;
        } else {
            // Handle the case where the user was not found
            throw new IllegalArgumentException("User not found with ID: " + userId);
        }
    }

    public UserDto getUserInfo(UUID userId) {
        Optional<User> optionalUser = userRepository.findById(userId);
        if (optionalUser.isPresent()) {
            User user = optionalUser.get();
            return userMapper.convertUserToUserDto(user);
        }
        else {
            throw new IllegalArgumentException("User not found with ID: " + userId);
        }
    }

    private String createVerificationCode() {
        final int CODE_LENGTH = 6;
        final char[] DIGITS = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' };

        final var random = new SecureRandom();

        String code = "";
        for (int i = 0; i < CODE_LENGTH; i++) {
            final var index = random.nextInt(DIGITS.length);
            code += DIGITS[index];
        }

        return code;
    }
}