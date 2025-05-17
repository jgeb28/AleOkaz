package pl.aleokaz.backend.fishingspot;

import org.springframework.stereotype.Service;

@Service
public class FishingSpotMapper {
    public FishingSpotDto convertFishingSpotToFishingSpotDto(FishingSpot fishingSpot) {
        return FishingSpotDto.builder()
            .id(fishingSpot.id())
            .name(fishingSpot.name())
            .description(fishingSpot.description())
            .ownerId(fishingSpot.owner().id())
            .latitude(fishingSpot.location().getY())
            .longitude(fishingSpot.location().getX())
            .build();
    }
}
