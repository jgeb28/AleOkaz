package pl.aleokaz.backend.post;

import lombok.Builder;
import lombok.Data;
import lombok.NonNull;

@Data
@Builder
public class UpdatePostCommand {
    @NonNull
    private String title;
    @NonNull
    private String content;
}
