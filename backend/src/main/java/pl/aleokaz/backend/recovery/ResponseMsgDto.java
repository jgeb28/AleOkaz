package pl.aleokaz.backend.recovery;

import jakarta.validation.constraints.NotNull;
import lombok.Builder;

@Builder
record ResponseMsgDto(
                @NotNull String message) {
}