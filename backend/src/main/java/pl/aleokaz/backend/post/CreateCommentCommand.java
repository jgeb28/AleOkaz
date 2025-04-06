package pl.aleokaz.backend.post;

import java.util.UUID;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NonNull;

@Data
@AllArgsConstructor
public class CreateCommentCommand {
    private UUID parentId;

    @NonNull
    private String content;
}
