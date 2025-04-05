package pl.aleokaz.backend.kafka;

import java.io.IOException;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.CopyOnWriteArrayList;

import org.springframework.stereotype.Service;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

@Service
public class SseService {
    private final List<UserEmitter> emitters = new CopyOnWriteArrayList<>();

    public SseEmitter streamNotifications(String username) {
        UUID id = UUID.randomUUID();
        SseEmitter emitter = new SseEmitter(0L);
        emitters.add(new UserEmitter(id, username, emitter));

        emitter.onCompletion(() -> emitters.removeIf(e -> e.username.equals(username)));
        emitter.onTimeout(() -> emitters.removeIf(e -> e.username.equals(username)));
        emitter.onError((ex) -> emitters.removeIf(e -> e.username.equals(username)));

        return emitter;
    }

    public boolean broadcasrToUsers(String message, String username) {
        boolean messageSent = false;
        for (UserEmitter userEmitter : emitters) {
            if (userEmitter.username.equals(username)) {
                try {
                    userEmitter.emitter.send(SseEmitter.event().data(message));
                    messageSent = true;
                } catch (IOException e) {
                    emitters.remove(userEmitter);
                    userEmitter.emitter.completeWithError(e);
                    e.printStackTrace();
                }
            }
        }
        return messageSent;
    }
}
