package pl.aleokaz.backend.fishingspot;

import lombok.Builder;
import lombok.Data;
import lombok.NonNull;

@Data
@Builder
public class FishingSpotUpdateCommand {
    private String name;

    private String description;

    private double latitude;
    private double longitude;
}
