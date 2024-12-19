package pl.aleokaz.backend.recovery;

import jakarta.validation.constraints.NotBlank;
import lombok.Builder;
import lombok.Data;
import lombok.NonNull;

@Data
@Builder
public class RecoveryCommand {
    //Sorry, I had to do this
    private Void _privateFieldThatShouldBeLeftIgnoredBecauseRequestBodyDoesntWorkPropperlyWithClassesWithOneField;

    @NonNull
    @NotBlank
    private String email;
}
