package pl.aleokaz.backend.user.commands;

import jakarta.validation.constraints.NotBlank;
import lombok.Builder;
import lombok.Data;
import lombok.NonNull;

@Data
@Builder
public class LoginCommand {
        @NonNull
        @NotBlank
        private String username;

        @NonNull
        @NotBlank
        private char[] password;
}
