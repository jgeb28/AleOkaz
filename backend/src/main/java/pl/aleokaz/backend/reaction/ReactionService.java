package pl.aleokaz.backend.reaction;

import pl.aleokaz.backend.interaction.Interaction;
import pl.aleokaz.backend.interaction.InteractionService;
import pl.aleokaz.backend.reaction.commands.ReactionCommand;
import pl.aleokaz.backend.user.User;
import pl.aleokaz.backend.user.UserService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import lombok.NonNull;

import java.util.Set;
import java.util.UUID;

@Service
public class ReactionService {
    @Autowired
    private UserService userService;

    @Autowired
    private InteractionService interactionService;

    public void setReaction(@NonNull UUID userId, @NonNull UUID interactionId, @NonNull ReactionCommand reactionCommand) {
        User author = userService.getUserById(userId);
        Interaction interaction = interactionService.getInteractionById(interactionId);

        Set<Reaction> reactions = interaction.reactions();
        reactions.removeIf(reaction -> reaction.author().id().equals(userId));
        reactions.add(Reaction.builder()
                .type(reactionCommand.reactionType())
                .author(author)
                .interaction(interaction)
                .build());

        interactionService.saveInteraction(interaction);
    }

    public void deleteReaction(@NonNull UUID userId, @NonNull UUID interactionId) {
        userService.getUserById(userId);
        Interaction interaction = interactionService.getInteractionById(interactionId);
        Set<Reaction> reactions = interaction.reactions();
        reactions.removeIf(reaction -> reaction.author().id().equals(userId));
        interactionService.saveInteraction(interaction);
    }

    public static ReactionsDTO reactionsAsReactionsDto(Set<Reaction> reactions, User user) {
        ReactionsDTO result = new ReactionsDTO();

        for (Reaction reaction : reactions) {
            if (reaction.author().equals(user)) {
                result.userReaction(reaction.type());
            }

            switch (reaction.type()) {
                case LIKE -> result.likes(result.likes() + 1);
                case HEART -> result.hearts(result.hearts() + 1);
                case LAUGH -> result.laughs(result.laughs() + 1);
                case WOW -> result.wows(result.wows() + 1);
                case FISH -> result.fish(result.fish() + 1);
            }
        }
        return result;
    }
}
