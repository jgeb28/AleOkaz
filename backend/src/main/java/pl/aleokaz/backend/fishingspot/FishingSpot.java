package pl.aleokaz.backend.fishingspot;

import org.locationtech.jts.geom.Point;
import jakarta.persistence.*;
import lombok.*;
import pl.aleokaz.backend.post.Post;
import pl.aleokaz.backend.user.User;

import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

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

    private String description="";

    @OneToOne
    @JoinColumn(name = "owner_id", nullable = false)
    @NonNull
    private User owner;

    @NonNull
    @Column(columnDefinition = "geometry(Point,4326)")
    private Point location;

    public FishingSpot(UUID id, String name, String description, User owner, Point location) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.owner = owner;
        this.location = location;
    }

}
