package pl.aleokaz.backend.user;

import lombok.Builder;
import lombok.NonNull;

@Builder
public record RefreshResponse(
    @NonNull String accessToken)
{}
