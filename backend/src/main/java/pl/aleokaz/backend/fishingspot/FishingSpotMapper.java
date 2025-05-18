package pl.aleokaz.backend.fishingspot;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import pl.aleokaz.backend.post.Interaction;
import pl.aleokaz.backend.post.InteractionMapper;
import pl.aleokaz.backend.post.PostDto;

import java.util.HashSet;

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
