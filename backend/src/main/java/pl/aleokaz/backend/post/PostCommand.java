package pl.aleokaz.backend.post;

import lombok.Builder;
import lombok.Data;
import lombok.NonNull;

import java.util.UUID;

@Data
@Builder
public class PostCommand {
    @NonNull
    private String title;
    @NonNull
    private String content;
    @NonNull
    private String imageBase64;
}
