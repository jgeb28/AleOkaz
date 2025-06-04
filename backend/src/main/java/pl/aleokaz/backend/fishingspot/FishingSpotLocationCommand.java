package pl.aleokaz.backend.fishingspot;

import lombok.Builder;
import lombok.Data;
import lombok.NonNull;

@Data
@Builder
public class FishingSpotLocationCommand {
    @NonNull private double latitude;
    @NonNull private double longitude;
}
