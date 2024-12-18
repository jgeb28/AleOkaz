package pl.aleokaz.backend.user;

import java.util.UUID;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

import lombok.NonNull;

@ResponseStatus(value = HttpStatus.NOT_FOUND)
class UserNotFoundException extends RuntimeException {
    UserNotFoundException(@NonNull UUID id) {
        super(formatMessage(id), null);
    }

    private static String formatMessage(UUID id) {
        final var message = String.format("User %s not found.", id);
        return message;
    }
}
