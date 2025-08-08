package pl.aleokaz.backend.comment.exceptions;

public class CommentNotFoundException extends RuntimeException {
    public CommentNotFoundException(String field, String value) {
        super(formatMessage(field, value), null);
    }

    private static String formatMessage(String field, String value) {
        return String.format("Comment with field %s and value %s doesn't exist.", field, value);
    }
}
