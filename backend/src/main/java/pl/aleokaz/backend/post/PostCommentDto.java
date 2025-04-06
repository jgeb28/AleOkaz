package pl.aleokaz.backend.post;

import lombok.Builder;
import lombok.NonNull;

import java.util.Set;
import java.util.Date;
import java.util.Map;
import java.util.UUID;

@Builder
public record PostCommentDto(
        @NonNull UUID id,
        @NonNull String content,
        @NonNull Date createdAt,
        Date editedAt,
        @NonNull UUID authorId,
        @NonNull Map<String, Integer> reactions,
        @NonNull Set<PostCommentDto> comments) {
}
