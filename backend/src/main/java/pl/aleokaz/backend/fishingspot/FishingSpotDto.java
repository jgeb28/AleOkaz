package pl.aleokaz.backend.fishingspot;

import lombok.Builder;
import lombok.NonNull;
import org.locationtech.jts.geom.Point;
import pl.aleokaz.backend.post.Post;
import pl.aleokaz.backend.post.PostDto;

import java.util.Set;
import java.util.UUID;

@Builder
public record FishingSpotDto(
    @NonNull UUID id,
    @NonNull String name,
    String description,
    @NonNull UUID ownerId,
    @NonNull double longitude,
    @NonNull double latitude
) {}
