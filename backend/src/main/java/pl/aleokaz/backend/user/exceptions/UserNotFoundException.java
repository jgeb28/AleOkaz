package pl.aleokaz.backend.user.exceptions;

public class UserNotFoundException extends RuntimeException {
    public UserNotFoundException(String field, String value) {
        super(formatMessage(field, value), null);
    }

    private static String formatMessage(String field, String value) {
        return String.format("User with field %s and value %s doesn't exist.", field, value);
    }
}
