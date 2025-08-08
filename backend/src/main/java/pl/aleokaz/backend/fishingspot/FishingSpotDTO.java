package pl.aleokaz.backend.fishingspot;

import lombok.Builder;
import lombok.NonNull;
import java.util.UUID;

@Builder
public record FishingSpotDTO(
        @NonNull UUID id,
        @NonNull String name,
        String description,
        @NonNull UUID ownerId,
        double longitude,
        double latitude) {
}
