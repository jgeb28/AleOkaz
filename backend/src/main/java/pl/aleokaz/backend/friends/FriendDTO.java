package pl.aleokaz.backend.friends;

import java.util.UUID;

import lombok.Builder;
import lombok.NonNull;

@Builder
record FriendDTO(
        @NonNull UUID friend_id,
        @NonNull boolean is_accepted,
        @NonNull boolean is_sender) {
}
