package pl.aleokaz.backend.friends;

import java.util.UUID;

import lombok.Builder;
import lombok.NonNull;

@Builder
record FriendDTO(
        @NonNull String username,
        @NonNull UUID id,
        @NonNull String avatar_url,
        boolean is_accepted,
        boolean is_sender) {
}
