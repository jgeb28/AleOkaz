package pl.aleokaz.backend.fishingspot;

import jakarta.transaction.Transactional;
import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.geom.Point;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import pl.aleokaz.backend.user.UserRepository;

import java.util.UUID;

@Service
@Transactional
public class FishingSpotService {
    @Autowired
    private FishingSpotRepository fishingSpotRepository;

    @Autowired
    private FishingSpotMapper fishingSpotMapper;

    @Autowired
    private UserRepository userRepository;

    private final GeometryFactory geometryFactory = new GeometryFactory();

    public FishingSpotDto createFishingSpot(UUID userId, FishingSpotCommand fishingSpotCommand) {
        final var owner = userRepository.findById(userId)
            .orElseThrow(() -> new RuntimeException("User not found"));

        Point location = geometryFactory.createPoint(new Coordinate(fishingSpotCommand.longitude(), fishingSpotCommand.latitude()));

        final var fishingSpot = FishingSpot.builder()
            .name(fishingSpotCommand.name())
            .description(fishingSpotCommand.description())
            .owner(owner)
            .location(location)
            .build();

        final var savedFishingSpot = fishingSpotRepository.save(fishingSpot);

        return fishingSpotMapper.convertFishingSpotToFishingSpotDto(savedFishingSpot);
    }
}
