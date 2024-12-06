package pl.aleokaz.backend.recovery;

import java.time.LocalDateTime;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import pl.aleokaz.backend.user.User;
import pl.aleokaz.backend.user.UserRepository;

@Service
public class RecoveryTokenService {
    @Autowired
    private UserRepository userRepository;

    @Autowired
    private TokenRepository tokenRepository;

    public RecoveryToken createRecoveryToken(RecoveryCommand recoveryCommand) throws Exception {
        User user = userRepository.findByEmail(recoveryCommand.email());
        if (user == null) {
            throw new Exception("User not found"); // TODO(marcin): create and handle special exception types
        }

        RecoveryToken recoveryToken = RecoveryToken.builder()
                .token(UUID.randomUUID().toString())
                .expirationDate(LocalDateTime.now().plusMinutes(15))
                .user(userRepository.findByEmail(recoveryCommand.email()))
                .build();
        tokenRepository.save(recoveryToken);
        return recoveryToken;
    }

    public boolean verifyRecoveryToken(CheckTokenCommand checkTokenCommand) throws Exception {
        User user = userRepository.findByEmail(checkTokenCommand.email());
        if (user == null) {
            throw new Exception("User not found"); // TODO(marcin): create and handle special exception types
        }

        UUID userId = user.id();
        RecoveryToken recoveryToken = tokenRepository.findByUserId(userId);
        if (recoveryToken != null && recoveryToken.token().equals(checkTokenCommand.token())) {
            return true;
        }
        return false;
    }
}
