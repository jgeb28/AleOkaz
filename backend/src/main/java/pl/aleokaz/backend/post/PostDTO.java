package pl.aleokaz.backend.post;

import lombok.Builder;
import lombok.NonNull;
import pl.aleokaz.backend.comment.CommentDTO;
import pl.aleokaz.backend.reaction.ReactionsDTO;

import java.util.Date;
import java.util.Set;
import java.util.UUID;

@Builder
public record PostDTO(
        @NonNull UUID id,
        @NonNull String content,
        @NonNull String imageUrl,
        @NonNull Date createdAt,
        Date editedAt,
        @NonNull UUID authorId,
        @NonNull UUID fishingSpotId,
        @NonNull ReactionsDTO reactions,
        @NonNull Set<CommentDTO> comments) {
}
