package pl.aleokaz.backend.kafka;

import java.io.IOException;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.CopyOnWriteArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

@Service
public class SseService {
    @Autowired
    private KafkaListenerCreator kafkaListenerCreator;

    private final List<UserEmitter> emitters = new CopyOnWriteArrayList<>();

    public SseEmitter streamNotifications(String username) {
        SseEmitter emitter = new SseEmitter(0L);
        String listener_id = kafkaListenerCreator.createAndRegisterListener(username);
        UserEmitter userEmitter = new UserEmitter(listener_id, username, emitter);
        emitters.add(userEmitter);

        emitter.onCompletion(() -> {
            emitters.removeIf(e -> e.username.equals(username));
            kafkaListenerCreator.unregisterListener(listener_id);
        });
        emitter.onTimeout(() -> {
            emitters.removeIf(e -> e.username.equals(username));
            kafkaListenerCreator.unregisterListener(listener_id);
        });
        emitter.onError((ex) -> {
            emitters.removeIf(e -> e.username.equals(username));
            kafkaListenerCreator.unregisterListener(listener_id);
        });

        return emitter;
    }

    public boolean broadcastToUsers(String message, String username) {
        boolean messageSent = false;
        for (UserEmitter userEmitter : emitters) {
            if (userEmitter.username.equals(username)) {
                try {
                    userEmitter.emitter.send(SseEmitter.event().data(message));
                    messageSent = true;
                } catch (IOException e) {
                    kafkaListenerCreator.unregisterListener(userEmitter.listener_id);
                    emitters.remove(userEmitter);
                    userEmitter.emitter.completeWithError(e);
                    e.printStackTrace();
                }
            }
        }
        return messageSent;
    }
}
