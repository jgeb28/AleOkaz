package pl.aleokaz.backend.util;

import jakarta.validation.constraints.NotNull;
import lombok.Builder;

@Builder
public record ResponseMsgDTO(
        @NotNull String message) {
}