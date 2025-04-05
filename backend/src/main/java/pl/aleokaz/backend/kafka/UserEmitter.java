package pl.aleokaz.backend.kafka;

import java.util.UUID;

import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

public class UserEmitter {
    public UUID id;
    public String username;
    public SseEmitter emitter;

    public UserEmitter(UUID id, String username, SseEmitter emitter) {
        this.id = id;
        this.username = username;
        this.emitter = emitter;
    }
}
