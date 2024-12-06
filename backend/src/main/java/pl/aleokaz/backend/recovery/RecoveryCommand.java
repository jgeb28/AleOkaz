package pl.aleokaz.backend.recovery;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class RecoveryCommand {
    @NotNull
    @NotBlank
    private String email;
}
