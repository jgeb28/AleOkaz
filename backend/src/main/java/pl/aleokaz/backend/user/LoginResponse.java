package pl.aleokaz.backend.user;

import lombok.*;

import java.util.UUID;

@Builder
record LoginResponse(
    @NonNull String token,
    @NonNull String tokenType,
    @NonNull long expiresIn)
{}
