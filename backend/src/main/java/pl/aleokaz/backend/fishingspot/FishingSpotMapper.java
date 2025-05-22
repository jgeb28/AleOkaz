package pl.aleokaz.backend.fishingspot;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import pl.aleokaz.backend.post.Interaction;
import pl.aleokaz.backend.post.InteractionMapper;
import pl.aleokaz.backend.post.Post;
import pl.aleokaz.backend.post.PostDto;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;

@Service
public class FishingSpotMapper {
    @Autowired InteractionMapper interactionMapper;

    public FishingSpotDto convertFishingSpotToFishingSpotDto(FishingSpot fishingSpot) {
        var postDtos = new ArrayList<PostDto>();

        for (final var post : fishingSpot.posts()) {
            postDtos.add(interactionMapper.convertPostToPostDto(post, post.author()));
        }

        return FishingSpotDto.builder()
            .id(fishingSpot.id())
            .name(fishingSpot.name())
            .description(fishingSpot.description())
            .ownerId(fishingSpot.owner().id())
            .latitude(fishingSpot.location().getY())
            .longitude(fishingSpot.location().getX())
            .posts(postDtos)
            .build();
    }
}
