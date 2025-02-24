package pl.aleokaz.backend.recovery;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/recovery")
public class RecoveryController {
    @Autowired
    private RecoveryService recoveryService;

    @PostMapping
    public ResponseEntity<ResponseMsgDto> createAndSendRecoveryToken(@RequestBody RecoveryCommand recoveryCommand) {
        try {
            recoveryService.createAndSendRecoveryToken(recoveryCommand);
            return ResponseEntity.ok().body(ResponseMsgDto.builder().message("Recovery code sent.").build());
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ResponseMsgDto.builder().message("An issue occured while generating recovery code.").build());
        }
    }

    @PostMapping("/verifyToken")
    public ResponseEntity<ResponseMsgDto> verifyRecoveryToken(@RequestBody CheckTokenCommand checkTokenCommand) {
        try {
            if(recoveryService.verifyRecoveryToken(checkTokenCommand)) {
                return ResponseEntity.ok().body(ResponseMsgDto.builder().message("Recovery code verified.").build());
            } else {
                return ResponseEntity.badRequest().body(ResponseMsgDto.builder().message("Recovery code could not be verified.").build());
            }
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ResponseMsgDto.builder().message("An issue occured while verifying recovry code.").build());
        }
    }

    @PostMapping("/resetPassword")
    public ResponseEntity<ResponseMsgDto> resetPassword(@RequestBody ResetPasswordCommand resetPasswordCommand) {
        try {
            if(recoveryService.resetPassword(resetPasswordCommand)) {
                return ResponseEntity.ok().body(ResponseMsgDto.builder().message("Password reset.").build());
            } else {
                return ResponseEntity.badRequest().body(ResponseMsgDto.builder().message("Password could not be reset.").build());
            }
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ResponseMsgDto.builder().message("An issue occured while reseting the password.").build());
        }
    }
}
