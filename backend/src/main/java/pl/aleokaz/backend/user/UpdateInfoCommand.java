package pl.aleokaz.backend.user;

import jakarta.validation.constraints.NotBlank;
import lombok.Builder;
import lombok.Data;
import lombok.NonNull;

@Data
@Builder
public class UpdateInfoCommand {
    private Void __ignore;

    private String username;
}
