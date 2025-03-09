package pl.aleokaz.backend.post;

import lombok.Builder;
import lombok.NonNull;

import java.util.Date;
import java.util.UUID;

@Builder
public record PostDto(
    @NonNull UUID id,
    @NonNull String content,
    @NonNull String imageUrl,
    @NonNull Date createdAt,
    Date editedAt,
    @NonNull UUID authorId
){}
