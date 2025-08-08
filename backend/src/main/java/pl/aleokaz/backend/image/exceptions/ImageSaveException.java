package pl.aleokaz.backend.image.exceptions;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(value = HttpStatus.SERVICE_UNAVAILABLE)
public class ImageSaveException extends RuntimeException {
    public ImageSaveException() {
        super(message(), null);
    }

    private static String message() {
        return "Image could not be saved";
    }
}
