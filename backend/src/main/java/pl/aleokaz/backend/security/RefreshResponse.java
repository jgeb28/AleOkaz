package pl.aleokaz.backend.security;

import lombok.Builder;
import lombok.NonNull;

@Builder
public record RefreshResponse(
    @NonNull String accessToken)
{}
