package pl.aleokaz.backend.fishingspot;

import jakarta.transaction.Transactional;
import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.geom.Point;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import pl.aleokaz.backend.user.AuthorizationException;
import pl.aleokaz.backend.user.UserRepository;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

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

    public FishingSpotDto getFishingSpotById(UUID id) {
        final var fishingSpot = fishingSpotRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Fishing Spot not found"));

        return fishingSpotMapper.convertFishingSpotToFishingSpotDto(fishingSpot);
    }

    public List<FishingSpotDto> getAllFishingSpots() {
        final List<FishingSpot> fishingSpots = fishingSpotRepository.findAll();

        final List<FishingSpotDto> fishingSpotDtos = fishingSpots.stream()
            .map(fs -> fishingSpotMapper.convertFishingSpotToFishingSpotDto(fs))
            .collect(Collectors.toList());

        return fishingSpotDtos;
    }

    public List<FishingSpotDto> getAllFishingSpotsSortedByDistance(double longitude, double latitude) {
        final List<FishingSpot> fishingSpots = fishingSpotRepository.getSortedByDistance(longitude, latitude);

        final List<FishingSpotDto> fishingSpotDtos = fishingSpots.stream()
            .map(fs -> fishingSpotMapper.convertFishingSpotToFishingSpotDto(fs))
            .collect(Collectors.toList());

        return fishingSpotDtos;
    }

    public FishingSpotDto getClosestFishingSpot(double longitude, double latitude) {
        var closestSpot = fishingSpotRepository.getSortedByDistance(longitude, latitude).getFirst();

        return fishingSpotMapper.convertFishingSpotToFishingSpotDto(closestSpot);
    }

    public List<FishingSpotDto> getPostedInFishingSpots(UUID userId) {
        final var owner = userRepository.findById(userId)
            .orElseThrow(() -> new RuntimeException("User not found"));

        final List<FishingSpot> fishingSpots = fishingSpotRepository.findByUserPosts(owner.id());

        final List<FishingSpotDto> fishingSpotDtos = fishingSpots.stream()
            .map(fs -> fishingSpotMapper.convertFishingSpotToFishingSpotDto(fs))
            .collect(Collectors.toList());

        return fishingSpotDtos;
    }

    public FishingSpotDto updateFishingSpot(UUID userId, UUID id, FishingSpotUpdateCommand fishingSpotUpdateCommand) {
        final var owner = userRepository.findById(userId)
            .orElseThrow(() -> new RuntimeException("User not found"));

        final var fishingSpot = fishingSpotRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Fishing Spot not found"));

        if (!owner.equals(fishingSpot.owner())) {
            throw new AuthorizationException(userId.toString());
        }

        if(fishingSpotUpdateCommand.name() != null) {
            fishingSpot.name(fishingSpotUpdateCommand.name());
        }
        if (fishingSpotUpdateCommand.description() != null) {
            fishingSpot.description(fishingSpotUpdateCommand.description());
        }
        if (fishingSpotUpdateCommand.latitude() != 0 && fishingSpotUpdateCommand.longitude() != 0) {
            Point location = geometryFactory.createPoint(new Coordinate(fishingSpotUpdateCommand.longitude(), fishingSpotUpdateCommand.latitude()));
            fishingSpot.location(location);
        }

        final var savedFishingSpot = fishingSpotRepository.save(fishingSpot);

        return fishingSpotMapper.convertFishingSpotToFishingSpotDto(savedFishingSpot);
    }
}
