package pl.aleokaz.backend.fishingspot;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import pl.aleokaz.backend.fishingspot.commands.FishingSpotCommand;
import pl.aleokaz.backend.fishingspot.commands.FishingSpotLocationCommand;
import pl.aleokaz.backend.fishingspot.commands.FishingSpotUpdateCommand;
import pl.aleokaz.backend.security.AuthenticationService;

import java.util.List;
import java.util.UUID;
// TODO: Controller rework
// /api/fishingspots GET - get all
// /api/fishingspots/sorted GET - get all sorted by distance
@RestController
@RequestMapping("/api/fishingspots")
public class FishingSpotController {
    @Autowired
    private AuthenticationService authenticationService;

    @Autowired
    private FishingSpotService fishingSpotService;

    @GetMapping("/all")
    public ResponseEntity<List<FishingSpotDTO>> getAllFishingSpots() {
        List<FishingSpot> fishingSpots = fishingSpotService.getAllFishingSpots();
        return new ResponseEntity<>(fishingSpotService.fishingSpotsAsFishingSpotDTOs(fishingSpots), HttpStatus.OK);
    }

    @GetMapping("/sorted")
    public ResponseEntity<List<FishingSpotDTO>> getAllFishingSpotsSortedByDistance(
                @RequestBody FishingSpotLocationCommand fishingSpotLocationCommand) {
        double lon = fishingSpotLocationCommand.longitude();
        double lat = fishingSpotLocationCommand.latitude();
        List<FishingSpot> spotsSorted = fishingSpotService.getAllFishingSpotsSortedByDistance(lon, lat);
        if (spotsSorted == null || spotsSorted.isEmpty())
            return new ResponseEntity<>(HttpStatus.NO_CONTENT);
        return new ResponseEntity<>(fishingSpotService.fishingSpotsAsFishingSpotDTOs(spotsSorted), HttpStatus.OK);
    }

    @GetMapping("/closest")
    public ResponseEntity<FishingSpotDTO> getFishingSpotClosest(
                @RequestBody FishingSpotLocationCommand fishingSpotLocationCommand) {
        double lon = fishingSpotLocationCommand.longitude();
        double lat = fishingSpotLocationCommand.latitude();
        FishingSpot closestFishingSpot = fishingSpotService.getClosestFishingSpot(lon, lat);
        if (closestFishingSpot == null)
            return new ResponseEntity<>(HttpStatus.NO_CONTENT);
        return new ResponseEntity<>(closestFishingSpot.asFishingSpotDTO(), HttpStatus.OK);
    }

    @GetMapping("/postedIn")
    public ResponseEntity<List<FishingSpotDTO>> getPostedInFishingSpots(Authentication authentication) {
        UUID currentUserId = authenticationService.getCurrentUserId(authentication);
        List<FishingSpot> fishingSpots = fishingSpotService.getPostedInFishingSpots(currentUserId);
        if (fishingSpots == null || fishingSpots.isEmpty())
            return new ResponseEntity<>(HttpStatus.NO_CONTENT);
        return new ResponseEntity<>(fishingSpotService.fishingSpotsAsFishingSpotDTOs(fishingSpots), HttpStatus.OK);
    }

    @GetMapping("/id/{id}")
    public ResponseEntity<FishingSpotDTO> getFishingSpotById(@PathVariable UUID id) {
        FishingSpot fishingSpot = fishingSpotService.getFishingSpotById(id);
        if (fishingSpot == null)
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        return new ResponseEntity<>(fishingSpot.asFishingSpotDTO(), HttpStatus.OK);
    }

    @PostMapping
    public ResponseEntity<FishingSpotDTO> createFishingSpot(Authentication authentication,
                @RequestBody FishingSpotCommand fishingSpotCommand) {
        UUID currentUserId = authenticationService.getCurrentUserId(authentication);
        FishingSpot createdFishingSpot = fishingSpotService.createFishingSpot(currentUserId, fishingSpotCommand);
        if (createdFishingSpot == null)
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        return new ResponseEntity<>(createdFishingSpot.asFishingSpotDTO(), HttpStatus.CREATED);
    }

    @PutMapping("/{id}")
    public ResponseEntity<FishingSpotDTO> updateFishingSpot(Authentication authentication, @PathVariable UUID id,
                @RequestBody FishingSpotUpdateCommand fishingSpotUpdateCommand) {
        UUID currentUserId = authenticationService.getCurrentUserId(authentication);
        FishingSpot fishingSpot = fishingSpotService.updateFishingSpot(currentUserId, id, fishingSpotUpdateCommand);
        if (fishingSpot == null)
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        return new ResponseEntity<>(fishingSpot.asFishingSpotDTO(), HttpStatus.OK);
    }
}
