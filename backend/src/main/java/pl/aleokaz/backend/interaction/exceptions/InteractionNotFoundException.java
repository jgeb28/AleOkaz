package pl.aleokaz.backend.interaction.exceptions;

public class InteractionNotFoundException extends RuntimeException {
    public InteractionNotFoundException(String field, String value) {
        super(formatMessage(field, value), null);
    }

    private static String formatMessage(String field, String value) {
        return String.format("Interaction with field %s and value %s doesn't exist.", field, value);
    }
}
