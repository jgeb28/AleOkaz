package pl.aleokaz.backend.kafka;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class KafkaController {
    @Autowired
    private KafkaTemplate<String, String> kafkaTemplate;

    @Autowired
    private KafkaService kafkaService;

    @PostMapping("/send")
    public String sendMessage(@RequestParam("message") String message) {
        kafkaService.sendMessage("notification", message);
        kafkaTemplate.send("notification", "id1", message);
        return "Message sent: " + message;
    }

}