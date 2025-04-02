package pl.aleokaz.backend.post;

import lombok.NonNull;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(value = HttpStatus.SERVICE_UNAVAILABLE)
public class PostSaveException extends RuntimeException {
    public PostSaveException() {
        super(message(), null);
    }

    private static String message() {
        return "Post could not be saved";
    }
}
