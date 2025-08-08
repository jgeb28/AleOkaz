package pl.aleokaz.backend.fishingspot;

import org.locationtech.jts.geom.Point;
import jakarta.persistence.*;
import lombok.*;
import pl.aleokaz.backend.post.Post;
import pl.aleokaz.backend.user.User;

import java.util.*;

@Entity
@Data
@NoArgsConstructor
@Builder
public class FishingSpot {
    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @NonNull
    private String name;

    @Builder.Default
    private String description = "";

    @OneToOne
    @JoinColumn(name = "owner_id", nullable = false)
    @NonNull
    private User owner;

    @NonNull
    @Column(columnDefinition = "geometry(Point,4326)")
    private Point location;

    @NonNull
    @OneToMany(mappedBy = "fishingSpot")
    private List<Post> posts;

    public FishingSpot(UUID id, String name, String description, User owner, Point location, List<Post> posts) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.owner = owner;
        this.location = location;

        if(posts == null) {
            this.posts = new ArrayList<>();
        } else {
            this.posts = new ArrayList<>(posts);
        }
    }

    public FishingSpotDTO asFishingSpotDTO() {
        return FishingSpotDTO.builder()
            .id(id())
            .name(name())
            .description(description())
            .ownerId(owner().id())
            .latitude(location().getY())
            .longitude(location().getX())
            .build();
    }
}
