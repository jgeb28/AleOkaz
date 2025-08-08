package pl.aleokaz.backend.recovery.commands;

import jakarta.validation.constraints.NotBlank;
import lombok.Builder;
import lombok.Data;
import lombok.NonNull;

@Data
@Builder
public class RecoveryCommand {
    private Void _emptyField;

    @NonNull
    @NotBlank
    private String email;
}
