package pl.aleokaz.backend.user.login;

import lombok.*;

import java.util.Date;

@Builder
public record LoginResponse(
    @NonNull String accessToken,
    @NonNull Date expiresAt,
    @NonNull String refreshToken,
    @NonNull Date refreshExpiresAt)
{}
