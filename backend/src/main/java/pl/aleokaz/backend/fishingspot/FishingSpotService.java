package pl.aleokaz.backend.fishingspot;

import jakarta.transaction.Transactional;
import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.geom.Point;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import pl.aleokaz.backend.fishingspot.commands.FishingSpotCommand;
import pl.aleokaz.backend.fishingspot.commands.FishingSpotUpdateCommand;
import pl.aleokaz.backend.fishingspot.exceptions.FishingSpotNotFoundException;
import pl.aleokaz.backend.user.User;
import pl.aleokaz.backend.user.UserService;

import java.util.List;
import java.util.UUID;

@Service
@Transactional
public class FishingSpotService {
    @Autowired
    private FishingSpotRepository fishingSpotRepository;

    @Autowired
    private UserService userService;

    private final GeometryFactory geometryFactory = new GeometryFactory();

    public FishingSpot getFishingSpotById(UUID id) {
        return fishingSpotRepository.findById(id)
            .orElseThrow(() -> new FishingSpotNotFoundException("id", id.toString()));
    }

    public List<FishingSpot> getAllFishingSpots() {
        return fishingSpotRepository.findAll();
    }

    public List<FishingSpot> getAllFishingSpotsSortedByDistance(double longitude, double latitude) {
        return fishingSpotRepository.getSortedByDistance(longitude, latitude);
    }

    public FishingSpot getClosestFishingSpot(double longitude, double latitude) {
        return fishingSpotRepository.getSortedByDistance(longitude, latitude).getFirst();
    }

    public List<FishingSpot> getPostedInFishingSpots(UUID userId) {
        User owner = userService.getUserById(userId);
        return fishingSpotRepository.findByUserPosts(owner.id());
    }
    
    public List<FishingSpotDTO> fishingSpotsAsFishingSpotDTOs(List<FishingSpot> fishingSpots) {
        return fishingSpots.stream()
            .map(FishingSpot::asFishingSpotDTO)
            .toList();
    }
    
    public FishingSpot createFishingSpot(UUID userId, FishingSpotCommand fishingSpotCommand) {
        User owner = userService.getUserById(userId);
        Point location = geometryFactory.createPoint(new Coordinate(fishingSpotCommand.longitude(), fishingSpotCommand.latitude()));

        FishingSpot fishingSpot = FishingSpot.builder()
            .name(fishingSpotCommand.name())
            .description(fishingSpotCommand.description())
            .owner(owner)
            .location(location)
            .build();

        return fishingSpotRepository.save(fishingSpot);
    }

    public FishingSpot updateFishingSpot(UUID userId, UUID id, FishingSpotUpdateCommand fishingSpotUpdateCommand) {
        User user = userService.getUserById(userId);

        FishingSpot fishingSpot = getFishingSpotById(id); 
        user.verifyAs(fishingSpot.owner());
        
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

        return fishingSpotRepository.save(fishingSpot);
    }
}
