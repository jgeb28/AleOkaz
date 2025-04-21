package pl.aleokaz.backend.kafka;

import org.springframework.security.core.Authentication;

import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

@RestController
@RequestMapping("/api/sse")
public class SseController {

    @Autowired
    private SseService sseService;

    @GetMapping("/notifications")
    public SseEmitter streamNotifications(Authentication authentication) {
        SseEmitter emitter = new SseEmitter();
        try {
            if (authentication == null) {
                emitter.completeWithError(new IllegalStateException("Unauthorized"));
                return emitter;
            }
            UUID currentUserId = UUID.fromString((String) authentication.getPrincipal());
            return sseService.streamNotifications(currentUserId.toString());
        } catch (Exception e) {
            emitter.completeWithError(e);
            return emitter;
        }
    }
}