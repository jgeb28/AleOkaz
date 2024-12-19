package pl.aleokaz.backend.recovery;

import jakarta.validation.constraints.NotBlank;
import lombok.Builder;
import lombok.Data;
import lombok.NonNull;

@Data
@Builder
public class CheckTokenCommand {
    @NonNull
    @NotBlank
    private String token;

    @NonNull
    @NotBlank
    private String email;
}
