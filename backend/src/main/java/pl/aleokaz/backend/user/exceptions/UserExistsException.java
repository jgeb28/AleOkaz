package pl.aleokaz.backend.user.exceptions;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

import lombok.NonNull;

@ResponseStatus(value = HttpStatus.BAD_REQUEST)
public class UserExistsException extends RuntimeException {
    public UserExistsException(@NonNull String field, @NonNull String value) {
        super(formatMessage(field, value), null);
    }

    private static String formatMessage(String field, String value) {
        final var message = String.format("User with field %s and value %s already exists.",
                field,
                value);
        return message;
    }
}
