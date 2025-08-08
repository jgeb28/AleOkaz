package pl.aleokaz.backend.user.commands;

import lombok.Builder;
import lombok.Data;
import lombok.extern.jackson.Jacksonized;

@Data
@Builder
@Jacksonized
public class UpdateInfoCommand {
    private Void __ignore;

    private String username;
}
