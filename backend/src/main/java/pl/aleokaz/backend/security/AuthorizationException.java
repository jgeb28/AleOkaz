package pl.aleokaz.backend.security;

import lombok.NonNull;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(value = HttpStatus.FORBIDDEN)
public class AuthorizationException extends RuntimeException {
    public AuthorizationException(@NonNull String userId) {
        super(formatMessage(userId), null);
    }

    private static String formatMessage(String userId) {
        final var message = String.format("User %s is not authorized to perform this action",
                userId);
        return message;
    }
}
