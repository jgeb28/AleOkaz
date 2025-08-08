package pl.aleokaz.backend.reaction.commands;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NonNull;
import pl.aleokaz.backend.reaction.ReactionType;

@Data
@AllArgsConstructor
public class ReactionCommand {
    private Void _empty;

    @NonNull
    private ReactionType reactionType;
}
