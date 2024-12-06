package pl.aleokaz.backend.recovery;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import pl.aleokaz.backend.user.UserRepository;
import pl.aleokaz.backend.user.User;

@Service
public class RecoveryService {
    @Autowired
    private RecoveryTokenService recoveryTokenService;

    @Autowired
    private UserRepository userRepository;

    public RecoveryService() {
        super();
    }

    public ResponseMsgDto createAndSendRecoveryToken(RecoveryCommand recoveryCommand) throws Exception {
        RecoveryToken recoveryToken = recoveryTokenService.createRecoveryToken(recoveryCommand);

        MailingService mailingService = MailingService.builder()
                .email(recoveryCommand.email())
                .subject("Recovery token")
                .message("Your recovery token is: " + recoveryToken.token())
                .build();
        mailingService.sendEmail();
        return ResponseMsgDto.builder().message(recoveryToken.token()).build();
    }

    public ResponseMsgDto verifyRecoveryToken(CheckTokenCommand checkTokenCommand) throws Exception {
        if (recoveryTokenService.verifyRecoveryToken(checkTokenCommand)) {
            return ResponseMsgDto.builder().message("Token validated").build();
        } else {
            return ResponseMsgDto.builder().message("Token could not be validated").build();
        }
    }

    public ResponseMsgDto resetPassword(ResetPasswordCommand resetPasswordCommand) throws Exception {
        CheckTokenCommand checkTokenCommand = CheckTokenCommand.builder()
                .email(resetPasswordCommand.email())
                .token(resetPasswordCommand.token())
                .build();
        if (recoveryTokenService.verifyRecoveryToken(checkTokenCommand)) {
            User user = userRepository.findByEmail(resetPasswordCommand.email());
            user.password(resetPasswordCommand.password());
            userRepository.save(user); // TODO(marcin): ask how you update
            return ResponseMsgDto.builder().message("Password reset").build();
        } else {
            return ResponseMsgDto.builder().message("Password could not be reset").build();
        }
    }
}