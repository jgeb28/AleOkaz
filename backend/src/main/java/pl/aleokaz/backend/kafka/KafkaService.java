package pl.aleokaz.backend.kafka;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.kafka.support.KafkaHeaders;
import org.springframework.messaging.handler.annotation.Header;
import org.springframework.stereotype.Service;

@Service
public class KafkaService {
    @Autowired
    private KafkaTemplate<String, String> kafkaTemplate;
    @Autowired
    private SseService sseService;

    public void sendMessage(String topic, String to, String message) {
        kafkaTemplate.send(topic, to + ":" + message);
    }

    public void sendMessage(String topic, String message) {
        kafkaTemplate.send(topic, message);
    }

    @KafkaListener(topics = "notification", groupId = "aleokaz")
    public void listen(String message, @Header(name = KafkaHeaders.RECEIVED_KEY, required = false) String key) {
        String[] parts = message.split(":", 2);
        if (parts.length == 2) {
            String to = parts[0];
            String notification = parts[1];

            if(!sseService.broadcasrToUsers(notification, to))
                sendMessage("notification", to, notification);
        } else {
            System.out.println("Received message without user: " + message);
        }
    }
}
