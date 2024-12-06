package pl.aleokaz.backend.user.login;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;
import lombok.NonNull;
import lombok.Builder;

@Data
@Builder
public class TokenCommand {
    private String id;

    @NonNull
    @NotBlank
    private String token;
}
