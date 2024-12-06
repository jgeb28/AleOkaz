package pl.aleokaz.backend.recovery;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class CheckTokenCommand {
    @NotNull
    @NotBlank
    private String token;

    @NotNull
    @NotBlank
    private String email;
}
