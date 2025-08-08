package pl.aleokaz.backend.friends.exceptions;

public class FriendshipNotFoundException extends RuntimeException {
    public FriendshipNotFoundException(String field, String value) {
        super(formatMessage(field, value), null);
    }

    private static String formatMessage(String field, String value) {
        return String.format("Friendship with field %s and value %s doesn't exist.", field, value);
    }
}