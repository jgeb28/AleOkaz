package pl.aleokaz.backend.kafka;

import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.springframework.kafka.listener.MessageListener;

public class KafkaTemplateListener implements MessageListener<String, String> {
    private final SseService sseService;

    public KafkaTemplateListener(SseService sseService) {
        this.sseService = sseService;
    }

    @Override
    public void onMessage(ConsumerRecord<String, String> record) {
        sseService.broadcastToUsers(record.value(), record.topic());
    }
}
