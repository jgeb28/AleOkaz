package pl.aleokaz.backend.friends;

import java.util.UUID;

import lombok.Builder;
import lombok.NonNull;

@Builder
record FriendDTO(
        @NonNull UUID friend_id,
        boolean is_accepted,
        boolean is_sender) {
}
