package pl.aleokaz.backend.recovery;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.factory.PasswordEncoderFactories;
import org.springframework.stereotype.Service;

import pl.aleokaz.backend.user.UserRepository;
import pl.aleokaz.backend.user.User;

@Service
public class RecoveryService {
    @Autowired
    private RecoveryTokenService recoveryTokenService;

    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private TokenRepository tokenRepository;

    public RecoveryService() {
        super();
    }

    public void createAndSendRecoveryToken(RecoveryCommand recoveryCommand) throws UserNotFoundException {
        RecoveryToken recoveryToken = recoveryTokenService.createRecoveryToken(recoveryCommand);

        MailingService mailingService = MailingService.builder()
                .email(recoveryCommand.email())
                .subject("Recovery token")
                .message("Your recovery token is: " + recoveryToken.token())
                .build();
        mailingService.sendEmail();
    }

    public boolean verifyRecoveryToken(CheckTokenCommand checkTokenCommand) throws UserNotFoundException, TokenNotFoundException {
        return recoveryTokenService.verifyRecoveryToken(checkTokenCommand);
    }

    public boolean resetPassword(ResetPasswordCommand resetPasswordCommand) throws Exception {
        CheckTokenCommand checkTokenCommand = CheckTokenCommand.builder()
                .email(resetPasswordCommand.email())
                .token(resetPasswordCommand.token())
                .build();

        if (recoveryTokenService.verifyRecoveryToken(checkTokenCommand)) {
            User user = userRepository.findByEmail(resetPasswordCommand.email());
            final var passwordEncoder = PasswordEncoderFactories.createDelegatingPasswordEncoder();
            final var encodedPassword = passwordEncoder.encode(String.valueOf(resetPasswordCommand.password()));
            user.password(encodedPassword);
            userRepository.save(user);
            RecoveryToken recoveryToken = tokenRepository.findByUserId(user.id());
            tokenRepository.delete(recoveryToken);
            return true;
        } 
        return false;
    }
}