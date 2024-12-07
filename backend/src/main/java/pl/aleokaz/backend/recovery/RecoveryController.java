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
            return ResponseEntity.ok(recoveryService.createAndSendRecoveryToken(recoveryCommand));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ResponseMsgDto.builder().message(e.getMessage()).build());
        }
    }

    @PostMapping("/verifyToken")
    public ResponseEntity<ResponseMsgDto> verifyRecoveryToken(@RequestBody CheckTokenCommand checkTokenCommand) {
        try {
            return ResponseEntity.ok(recoveryService.verifyRecoveryToken(checkTokenCommand));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ResponseMsgDto.builder().message(e.getMessage()).build());
        }
    }

    @PostMapping("/resetPassword")
    public ResponseEntity<ResponseMsgDto> resetPassword(@RequestBody ResetPasswordCommand resetPasswordCommand) {
        try {
            return ResponseEntity.ok(recoveryService.resetPassword(resetPasswordCommand));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(ResponseMsgDto.builder().message(e.getMessage()).build());
        }
    }
}
