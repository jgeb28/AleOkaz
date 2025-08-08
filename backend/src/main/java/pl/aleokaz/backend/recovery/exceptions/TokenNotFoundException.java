package pl.aleokaz.backend.recovery.exceptions;

public class TokenNotFoundException extends RuntimeException {
    public TokenNotFoundException(String field, String value) {
        super(formatMessage(field, value), null);
    }

    private static String formatMessage(String field, String value) {
        final var message = String.format("Token with field %s and value %s doesn't exists.", field, value);
        return message;
    }
}
