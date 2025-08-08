package pl.aleokaz.backend.fishingspot.exceptions;

public class FishingSpotNotFoundException extends RuntimeException {
    public FishingSpotNotFoundException(String field, String value) {
        super(formatMessage(field, value), null);
    }

    private static String formatMessage(String field, String value) {
        return String.format("Fishing spot with field %s and value %s doesn't exist.", field, value);
    }
}
