package pl.aleokaz.backend.recovery.commands;

import jakarta.validation.constraints.NotBlank;
import lombok.Builder;
import lombok.Data;
import lombok.NonNull;

@Data
@Builder
public class ResetPasswordCommand {
    @NonNull
    @NotBlank
    private String token;

    @NonNull
    @NotBlank
    private String email;

    @NonNull
    @NotBlank
    private String password;
}
