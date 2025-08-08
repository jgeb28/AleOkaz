package pl.aleokaz.backend.kafka;

import java.util.UUID;

import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.kafka.config.KafkaListenerContainerFactory;
import org.springframework.kafka.config.KafkaListenerEndpoint;
import org.springframework.kafka.config.KafkaListenerEndpointRegistry;
import org.springframework.kafka.config.MethodKafkaListenerEndpoint;
import org.springframework.messaging.handler.annotation.support.DefaultMessageHandlerMethodFactory;
import org.springframework.stereotype.Service;

@Service
public class KafkaListenerCreator {
    String commonKafkaGroupId = "aleokaz";
    String commonKafkaListenerId = "listener-";

    @Autowired
    private KafkaListenerEndpointRegistry kafkaListenerEndpointRegistry;

    @Autowired
    private KafkaListenerContainerFactory kafkaListenerContainerFactory;
    
    @Lazy
    @Autowired
    private SseService sseService;

    public String createAndRegisterListener(String topic) {
        String id = generateListenerId();
        KafkaListenerEndpoint listener = createKafkaListenerEndpoint(topic, id);
        kafkaListenerEndpointRegistry.registerListenerContainer(listener, kafkaListenerContainerFactory, true);
        return id;
    }

    public void unregisterListener(String id) {
        var container = kafkaListenerEndpointRegistry.getListenerContainer(id);
        if (container != null) {
            container.stop();
            kafkaListenerEndpointRegistry.unregisterListenerContainer(id);
        }
    }

    private KafkaListenerEndpoint createKafkaListenerEndpoint(String topic, String id) {
        MethodKafkaListenerEndpoint<String, String> kafkaListenerEndpoint =
            createDefaultMethodKafkaListenerEndpoint(topic, id);
        kafkaListenerEndpoint.setBean(new KafkaTemplateListener(sseService));
        try {
            kafkaListenerEndpoint.setMethod(KafkaTemplateListener.class.getMethod("onMessage", ConsumerRecord.class));
        } catch (NoSuchMethodException e) {
            throw new RuntimeException("Attempt to call a non-existent method " + e);
        }
        return kafkaListenerEndpoint;
    }

    private MethodKafkaListenerEndpoint<String, String> createDefaultMethodKafkaListenerEndpoint(String topic, String id) {
        MethodKafkaListenerEndpoint<String, String> kafkaListenerEndpoint = new MethodKafkaListenerEndpoint<>();
        kafkaListenerEndpoint.setId(id);
        kafkaListenerEndpoint.setGroupId(generateGroupId());
        kafkaListenerEndpoint.setAutoStartup(true);
        kafkaListenerEndpoint.setTopics(topic);
        kafkaListenerEndpoint.setMessageHandlerMethodFactory(new DefaultMessageHandlerMethodFactory());
        return kafkaListenerEndpoint;
    }

    private String generateListenerId() {
        return commonKafkaListenerId + UUID.randomUUID().toString();
    }

    private String generateGroupId() {
        return commonKafkaGroupId;
    }
}
