package pl.aleokaz.backend.exceptions;

public class UserNotFoundException extends RuntimeException {
    public UserNotFoundException(String field, String value) {
        super(formatMessage(field, value), null);
    }

    private static String formatMessage(String field, String value) {
        final var message = String.format("User with field %s and value %s doesn't exists.", field, value);
        return message;
    }
}
