package pl.aleokaz.backend.user;

import lombok.*;

@Builder
public record LoginResponse(
    @NonNull String accessToken,
    @NonNull String refreshToken)
{}
