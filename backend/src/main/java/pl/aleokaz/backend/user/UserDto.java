package pl.aleokaz.backend.user;

import lombok.Builder;
import lombok.NonNull;

import java.util.UUID;

@Builder
record UserDto(
        @NonNull UUID id,
        @NonNull String username,
        @NonNull String email,
        @NonNull String profilePicture) {
}
