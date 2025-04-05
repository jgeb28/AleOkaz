package pl.aleokaz.backend.kafka;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

@RestController
public class SseController {

    @Autowired
    private KafkaService kafkaService;

    @Autowired
    private SseService sseService;

    /* private final List<UserEmitter> emitters = new ArrayList<>(); */

    @GetMapping("/api/sse/notifications")
    public SseEmitter streamNotifications(@RequestParam String username) {
        return sseService.streamNotifications(username);
        /* UUID id = UUID.randomUUID();
        SseEmitter emitter = new SseEmitter(0L);
        emitters.add(new UserEmitter(id, username, emitter));

        emitter.onCompletion(() -> emitters.removeIf(e -> e.id.equals(id)));
        emitter.onTimeout(() -> emitters.removeIf(e -> e.id.equals(id)));
        emitter.onError((ex) -> emitters.removeIf(e -> e.id.equals(id))); */

/*         ScheduledExecutorService executor = Executors.newSingleThreadScheduledExecutor();
        AtomicBoolean isActive = new AtomicBoolean(true);

        executor.execute(() -> {
            try {
                while (isActive.get()) {
                    
                    String notification = kafkaService.getNotificationQueue(username).take();
                    SseEventBuilder event = SseEmitter.event().data(notification);
                    emitter.send(event);
                    Thread.sleep(1000);
                }
            } catch (IOException | InterruptedException e) {
                emitter.completeWithError(e);
            }
        }); */
        /* return emitter; */
    }
}