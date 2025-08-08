package pl.aleokaz.backend.security;

import lombok.*;

@Builder
public record LoginResponse(
    @NonNull String accessToken,
    @NonNull String refreshToken)
{}
