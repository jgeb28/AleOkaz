package pl.aleokaz.backend.post;

import lombok.Builder;
import lombok.Data;
import lombok.NonNull;

import java.util.UUID;

@Data
@Builder
public class PostCommand {
    private Void __ignore;

    @NonNull
    private String content;

    @NonNull
    private UUID fishingSpotId;
}
