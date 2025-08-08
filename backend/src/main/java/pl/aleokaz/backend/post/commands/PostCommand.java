package pl.aleokaz.backend.post.commands;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.NonNull;
import lombok.extern.jackson.Jacksonized;

import java.util.UUID;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Jacksonized
public class PostCommand {
    @NonNull
    private String content;

    @NonNull
    private UUID fishingSpotId;
}
