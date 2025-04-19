package pl.aleokaz.backend.post;

import pl.aleokaz.backend.user.UserRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import jakarta.transaction.Transactional;

import lombok.NonNull;

import java.util.Set;
import java.util.UUID;

@Service
@Transactional
public class ReactionService {
    @Autowired
    private UserRepository userRepository;

    @Autowired
    private InteractionRepository interactionRepository;

    public void setReaction(
            @NonNull UUID userId,
            @NonNull ReactionCommand command) {
        final var author = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        final var interaction = interactionRepository.findById(command.interactionId())
                .orElseThrow(() -> new RuntimeException("Interaction not found"));

        final Set<Reaction> reactions = interaction.reactions();
        reactions.removeIf(reaction -> reaction.author().id().equals(userId));
        reactions.add(Reaction.builder()
                .type(command.reactionType())
                .author(author)
                .interaction(interaction)
                .build());

        interactionRepository.save(interaction);
    }

    public void deleteReaction(@NonNull UUID userId, @NonNull UUID interactionId) {
        if (!userRepository.existsById(userId)) {
            throw new RuntimeException("User not found");
        }

        final var interaction = interactionRepository.findById(interactionId)
                .orElseThrow(() -> new RuntimeException("Interaction not found"));

        final Set<Reaction> reactions = interaction.reactions();
        reactions.removeIf(reaction -> reaction.author().id().equals(userId));

        interactionRepository.save(interaction);
    }
}
