package pl.aleokaz.backend.friends;

import lombok.Builder;
import lombok.NonNull;

@Builder
record FriendDTO(
        @NonNull String username,
        @NonNull String avatar_url) {
}
