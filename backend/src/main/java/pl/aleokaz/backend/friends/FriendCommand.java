package pl.aleokaz.backend.friends;

import jakarta.validation.constraints.NotBlank;
import lombok.Builder;
import lombok.Data;
import lombok.NonNull;

@Data
@Builder
public class FriendCommand {
    private Void _privateFieldThatShouldBeLeftIgnoredBecauseRequestBodyDoesntWorkPropperlyWithClassesWithOneField;

    @NonNull
    @NotBlank
    private String username;
}
