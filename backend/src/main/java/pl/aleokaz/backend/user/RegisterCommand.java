package pl.aleokaz.backend.user;

import jakarta.validation.constraints.NotBlank;
import lombok.Builder;
import lombok.Data;
import lombok.NonNull;

@Data
@Builder
class RegisterCommand {
        @NonNull
        @NotBlank
        private String username;

        @NonNull
        @NotBlank
        private String email;

        @NonNull
        @NotBlank
        private char[] password;
}
