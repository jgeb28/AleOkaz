package pl.aleokaz.backend.kafka;

import java.util.UUID;

import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

public class UserEmitter {
    public String listener_id;
    public String username;
    public SseEmitter emitter;

    public UserEmitter(String listener_id, String username, SseEmitter emitter) {
        this.listener_id = listener_id;
        this.username = username;
        this.emitter = emitter;
    }
}
