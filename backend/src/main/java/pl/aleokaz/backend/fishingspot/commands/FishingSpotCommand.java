package pl.aleokaz.backend.fishingspot.commands;

import jakarta.validation.constraints.NotBlank;
import lombok.Builder;
import lombok.Data;
import lombok.NonNull;

@Data
@Builder
public class FishingSpotCommand {
    @NonNull
    @NotBlank
    private String name;

    private String description;

    private double latitude;

    private double longitude;
}
