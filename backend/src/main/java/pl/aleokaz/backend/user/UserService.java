package pl.aleokaz.backend.user;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.crypto.factory.PasswordEncoderFactories;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.NonNull;
import org.springframework.web.multipart.MultipartFile;

import pl.aleokaz.backend.image.ImageService;
import pl.aleokaz.backend.image.exceptions.ImageSaveException;
import pl.aleokaz.backend.mail.MailingService;
import pl.aleokaz.backend.security.JwtTokenProvider;
import pl.aleokaz.backend.security.LoginResponse;
import pl.aleokaz.backend.security.RefreshResponse;
import pl.aleokaz.backend.security.Verification;
import pl.aleokaz.backend.security.VerificationRepository;
import pl.aleokaz.backend.user.commands.UpdateInfoCommand;
import pl.aleokaz.backend.user.exceptions.UserExistsException;
import pl.aleokaz.backend.user.exceptions.UserNotFoundException;

import java.io.IOException;
import java.security.SecureRandom;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Optional;
import java.util.Set;
import java.util.UUID;

@Service
@Transactional
public class UserService {
    final static Logger LOGGER = LoggerFactory.getLogger(UserService.class);

    private UserRepository userRepository;

    private VerificationRepository verificationRepository;

    private JwtTokenProvider jwtTokenProvider;

    @Value("${aleokaz.profile.picture.default}")
    private String defaultProfilePicture;

    @Value("${aleokaz.register.code.length}")
    private int verificationCodeLength;

    @Autowired
    private ImageService imageService;

    public UserService(@NonNull UserRepository userRepository,
                       @NonNull VerificationRepository verificationRepository,
                       @NonNull JwtTokenProvider jwtTokenProvider,
                       @NonNull ImageService imageService,
                       @NonNull MailingService mailingService) {
        this.userRepository = userRepository;
        this.verificationRepository = verificationRepository;
        this.jwtTokenProvider = jwtTokenProvider;
        this.imageService = imageService;
    }

    public User getUserByUsername(@NonNull String username) {
        User user = userRepository.findByUsername(username);
        if (user == null) {
            throw new UserNotFoundException("username", username);
        }
        return user;
    }

    public User getUserById(@NonNull UUID id) {
        return userRepository.findById(id)
                .orElseThrow(() -> new UserNotFoundException("id", id.toString()));
    }

    public User setUserPassword(@NonNull User user, @NonNull String password) {
        final var passwordEncoder = PasswordEncoderFactories.createDelegatingPasswordEncoder();
        final var encodedPassword = passwordEncoder.encode(String.valueOf(password));
        user.password(encodedPassword);
        return userRepository.save(user);
    }

    @PreAuthorize("permitAll()")
    public User registerUser(@NonNull String username,
                             @NonNull char[] password) {
        if (userRepository.existsByUsername(username)) {
            throw new UserExistsException("username", username);
        }
        // TODO(michalciechan): Minimalna entropia hasła?

        PasswordEncoder passwordEncoder = PasswordEncoderFactories.createDelegatingPasswordEncoder();
        String encodedPassword = passwordEncoder.encode(String.valueOf(password));
        for (int i = 0; i < password.length; i++) {
            password[i] = '\0';
        }

        Set<UserRole> roles = new HashSet<>(Arrays.asList(UserRole.UNVERIFIED_USER));
        var user = User.builder()
                .username(username)
                .password(encodedPassword)
                .roles(roles)
                .profilePicture(defaultProfilePicture)
                .build();
        user = userRepository.save(user);

        String verificationCode = createVerificationCode();

        Verification verification = Verification.builder()
                .user(user)
                .code(verificationCode)
                .build();
        verificationRepository.save(verification);

        return user;
    }

    @PreAuthorize("permitAll()")
    public LoginResponse loginUser(@NonNull String username,
                                   @NonNull char[] password) {
        User user = getUserByUsername(username);

        final PasswordEncoder passwordEncoder = PasswordEncoderFactories.createDelegatingPasswordEncoder();
        if (user == null || !passwordEncoder.matches(String.valueOf(password), user.password())) {
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
    public RefreshResponse refreshUserToken(@NonNull String refreshToken) {
        UUID userId = UUID.fromString(jwtTokenProvider.getUserIdFromToken(refreshToken));

        Optional<User> optionalUser = userRepository.findById(userId);
        if (optionalUser.isPresent()) {
            User user = optionalUser.get();
            String accessToken = jwtTokenProvider.refreshAccessToken(refreshToken, user);

            RefreshResponse refreshResponse = RefreshResponse.builder()
                .accessToken(accessToken)
                .build();
            return refreshResponse;
        } else {
            throw new UserNotFoundException("id", userId.toString());
        }
    }

    public User updateUserInfo(UUID userId, UpdateInfoCommand updateInfoCommand, MultipartFile image) {
        User user = getUserById(userId);
        
        if(updateInfoCommand != null) {
            if(!updateInfoCommand.username().isEmpty()) {
                user.username(updateInfoCommand.username());
            }
        }

        if(image != null && !image.isEmpty()) {
            try {
                user.profilePicture(imageService.saveProfilePicture(image));
            } catch (IOException e) {
                throw new ImageSaveException();
            }
        }
        return user;
    }

    private String createVerificationCode() {
        final var random = new SecureRandom();

        String code = "";
        for (int i = 0; i < verificationCodeLength; i++) {
            code += (char)('0'+ random.nextInt(10));
        }
        return code;
    }
}
