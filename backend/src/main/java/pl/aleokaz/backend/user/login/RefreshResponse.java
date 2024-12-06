package pl.aleokaz.backend.user.login;

import lombok.Builder;
import lombok.NonNull;

import java.util.Date;

@Builder
public record RefreshResponse(
    @NonNull String accessToken,
    @NonNull Date expiresAt)
{}
