package pl.aleokaz.backend.user.commands;

import jakarta.validation.constraints.NotBlank;
import lombok.Builder;
import lombok.Data;
import lombok.NonNull;

@Data
@Builder
public class RefreshCommand {
        private Void __ignore;

        @NonNull
        @NotBlank
        private String refreshToken;
}
