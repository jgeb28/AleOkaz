package pl.aleokaz.backend.fishingspot.commands;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class FishingSpotLocationCommand {
    private double latitude;
    
    private double longitude;
}
