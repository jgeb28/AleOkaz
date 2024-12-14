package pl.aleokaz.backend.user;

class UserExistsException extends RuntimeException {
    UserExistsException(String field, String value) {
        super(formatMessage(field, value), null);
    }

    private static String formatMessage(String field, String value) {
        final var message = String.format("User with field %s and value %s already exists.",
                field,
                value);
        return message;
    }
}
