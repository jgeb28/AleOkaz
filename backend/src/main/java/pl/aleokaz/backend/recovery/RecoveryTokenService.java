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

    public RecoveryToken createRecoveryToken(RecoveryCommand recoveryCommand) throws UserNotFoundException {
        User user = userRepository.findByEmail(recoveryCommand.email());
        if (user == null) {
            throw new UserNotFoundException("email", recoveryCommand.email());
        }

        RecoveryToken recoveryToken = RecoveryToken.builder()
                .token(UUID.randomUUID().toString())
                .expirationDate(LocalDateTime.now().plusMinutes(15))
                .user(userRepository.findByEmail(recoveryCommand.email()))
                .build();

        RecoveryToken existingToken = tokenRepository.findByUserId(user.id());
        if (existingToken != null) {
            existingToken.token(recoveryToken.token());
            existingToken.expirationDate(LocalDateTime.now().plusMinutes(15));//TODO: make expiration date configurable
            tokenRepository.save(existingToken);
        } else {
            tokenRepository.save(recoveryToken);
        }
        return recoveryToken;
    }

    public boolean verifyRecoveryToken(CheckTokenCommand checkTokenCommand) throws UserNotFoundException, TokenNotFoundException {
        User user = userRepository.findByEmail(checkTokenCommand.email());
        if (user == null) {
            throw new UserNotFoundException("email", checkTokenCommand.email());
        }

        UUID userId = user.id();
        RecoveryToken recoveryToken = tokenRepository.findByUserId(userId);
        if(recoveryToken == null) {
            throw new TokenNotFoundException("userId", user.id().toString());
        }
        if (recoveryToken.expirationDate().isAfter(LocalDateTime.now()) && recoveryToken.token().equals(checkTokenCommand.token())) {
            return true;
        } else {
            tokenRepository.delete(recoveryToken);//TODO(marcin): ask if we should remove token when incorrect input
            return false;
        }
    }
}
