package pl.aleokaz.backend.recovery;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import pl.aleokaz.backend.recovery.commands.RecoveryCommand;
import pl.aleokaz.backend.recovery.commands.ResetPasswordCommand;
import pl.aleokaz.backend.util.ResponseMsgDTO;

@RestController
@RequestMapping("/api/recovery")
public class RecoveryController {
    @Autowired
    private RecoveryService recoveryService;

/*     @PostMapping("/generate")
    public ResponseEntity<ResponseMsgDTO> createAndSendRecoveryToken(@RequestBody RecoveryCommand recoveryCommand) {
        recoveryService.createAndSendRecoveryToken(recoveryCommand.email());
        return ResponseEntity.ok().body(ResponseMsgDTO.builder().message("Recovery code sent.").build());
    }

    @PostMapping("/reset")
    public ResponseEntity<ResponseMsgDTO> resetPassword(@RequestBody ResetPasswordCommand resetPasswordCommand) {
        recoveryService.resetPassword(resetPasswordCommand);
        return ResponseEntity.ok().body(ResponseMsgDTO.builder().message("Password reset.").build());
    } */
}
