package pl.aleokaz.backend.fishingspot.commands;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class FishingSpotUpdateCommand {
    private String name;

    private String description;

    private double latitude;
    
    private double longitude;
}
