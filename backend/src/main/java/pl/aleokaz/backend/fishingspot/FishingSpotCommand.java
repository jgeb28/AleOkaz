package pl.aleokaz.backend.fishingspot;

import lombok.Builder;
import lombok.Data;
import lombok.NonNull;

@Data
@Builder
public class FishingSpotCommand {
    @NonNull
    private String name;

    private String description;

    @NonNull private double latitude;
    @NonNull private double longitude;
}
