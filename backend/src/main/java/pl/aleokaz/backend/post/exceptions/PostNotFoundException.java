package pl.aleokaz.backend.post.exceptions;

public class PostNotFoundException extends RuntimeException {
    public PostNotFoundException(String field, String value) {
        super(formatMessage(field, value), null);
    }

    private static String formatMessage(String field, String value) {
        return String.format("Post with field %s and value %s doesn't exist.", field, value);
    }
}
