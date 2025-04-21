package pl.aleokaz.backend.kafka;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

@RestController
@RequestMapping("/api/sse")
public class SseController {

    @Autowired
    private SseService sseService;

    @GetMapping("/notifications")
    public SseEmitter streamNotifications(@RequestParam String username) {
        return sseService.streamNotifications(username);
    }
}