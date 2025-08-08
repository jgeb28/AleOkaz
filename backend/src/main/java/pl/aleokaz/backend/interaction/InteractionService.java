package pl.aleokaz.backend.interaction;

import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import pl.aleokaz.backend.interaction.exceptions.InteractionNotFoundException;

@Service
public class InteractionService {
    @Autowired
    private InteractionRepository interactionRepository;

    public Interaction getInteractionById(UUID interactionId) {
        return interactionRepository.findById(interactionId)
                .orElseThrow(() -> new InteractionNotFoundException("id", interactionId.toString()));
    }

    public Interaction saveInteraction(Interaction interaction) {
        return interactionRepository.save(interaction);
    }
}
