package pl.aleokaz.backend.recovery;

import java.time.LocalDateTime;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import pl.aleokaz.backend.user.User;
import pl.aleokaz.backend.user.UserRepository;

@Service
public class RecoveryTokenService {
    @Autowired
    private UserRepository userRepository;

    @Autowired
    private TokenRepository tokenRepository;

    @Value("${recovery.token.expiration.minutes}")
    private int tokenExpirationMinutes;

    public RecoveryToken createRecoveryToken(RecoveryCommand recoveryCommand) throws UserNotFoundException {
        User user = userRepository.findByEmail(recoveryCommand.email());
        if (user == null) {
            throw new UserNotFoundException("email", recoveryCommand.email());
        }

        RecoveryToken recoveryToken = RecoveryToken.builder()
                .token(generateToken())
                .expirationDate(LocalDateTime.now().plusMinutes(tokenExpirationMinutes))
                .user(userRepository.findByEmail(recoveryCommand.email()))
                .build();

        RecoveryToken existingToken = tokenRepository.findByUserId(user.id());
        if (existingToken != null) {
            existingToken.token(recoveryToken.token());
            existingToken.expirationDate(LocalDateTime.now().plusMinutes(tokenExpirationMinutes));
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
        if(!recoveryToken.expirationDate().isAfter(LocalDateTime.now())){
            tokenRepository.delete(recoveryToken);
            return false;
        }
        if(recoveryToken.token().equals(checkTokenCommand.token())){
            return true;
        } else {
            recoveryToken.attempts(recoveryToken.attempts() + 1);
            if(recoveryToken.attempts() >= 3){
                tokenRepository.delete(recoveryToken);
            } else {
                tokenRepository.save(recoveryToken);
            }
            return false;
        }
    }

    private String generateToken() {
        String token = "";
        for(int i = 0; i < 7; i++) {
            token += (char) (Math.random() * 26 + 97);
        }
        return token;
    }
}
