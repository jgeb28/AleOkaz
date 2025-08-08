package pl.aleokaz.backend.comment.commands;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NonNull;

@Data
@AllArgsConstructor
public class UpdateCommentCommand {
    private Void _empty; 

    @NonNull
    @NotBlank
    private String content;
}
