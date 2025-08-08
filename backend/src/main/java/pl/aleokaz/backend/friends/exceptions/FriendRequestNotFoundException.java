package pl.aleokaz.backend.friends.exceptions;

public class FriendRequestNotFoundException extends RuntimeException {
    public FriendRequestNotFoundException(String field, String value) {
        super(formatMessage(field, value), null);
    }

    private static String formatMessage(String field, String value) {
        return String.format("Friend request with field %s and value %s doesn't exist.", field, value);
    }
}
