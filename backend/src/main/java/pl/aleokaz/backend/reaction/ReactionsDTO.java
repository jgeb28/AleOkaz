package pl.aleokaz.backend.reaction;

import com.fasterxml.jackson.annotation.JsonProperty;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Builder
@Data
@AllArgsConstructor
@NoArgsConstructor
public class ReactionsDTO {
    @JsonProperty
    private ReactionType userReaction;

    @JsonProperty
    private long likes;

    @JsonProperty
    private long hearts;

    @JsonProperty
    private long laughs;

    @JsonProperty
    private long wows;

    @JsonProperty
    private long fish;
}
