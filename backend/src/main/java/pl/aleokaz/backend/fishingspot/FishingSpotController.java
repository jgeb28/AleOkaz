package pl.aleokaz.backend.fishingspot;

import org.apache.coyote.Response;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import pl.aleokaz.backend.user.AuthorizationException;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/fishingspots")
public class FishingSpotController {
    @Autowired
    private FishingSpotService fishingSpotService;

    @GetMapping("/all")
    public ResponseEntity<List<FishingSpotDto>> getAllFishingSpots() {
        return new ResponseEntity<>(fishingSpotService.getAllFishingSpots(), HttpStatus.OK);
    }

    @GetMapping("/allsorted")
    public ResponseEntity<List<FishingSpotDto>> getAllFishingSpotsSortedByDistance(@RequestBody FishingSpotLocationCommand fishingSpotLocationCommand) {
        double lon = fishingSpotLocationCommand.longitude();
        double lat = fishingSpotLocationCommand.latitude();
        var spotsSorted = fishingSpotService.getAllFishingSpotsSortedByDistance(lon, lat);

        if (spotsSorted != null) return new ResponseEntity<>(fishingSpotService.getAllFishingSpotsSortedByDistance(lon, lat), HttpStatus.OK);
        else return new ResponseEntity<>(HttpStatus.NOT_FOUND);
    }

    @GetMapping("/{id}")
    public ResponseEntity<FishingSpotDto> getFishingSpotById(@PathVariable UUID id) {
        return ResponseEntity.ok(fishingSpotService.getFishingSpotById(id));
    }

    @PostMapping
    public ResponseEntity<FishingSpotDto> createFishingSpot(Authentication authentication, @RequestBody FishingSpotCommand fishingSpotCommand) {
        UUID currentUserId = UUID.fromString((String) authentication.getPrincipal());

        FishingSpotDto createdFishingSpot = fishingSpotService.createFishingSpot(currentUserId, fishingSpotCommand);
        return ResponseEntity.status(HttpStatus.CREATED).body(createdFishingSpot);
    }

    @GetMapping("/closest")
    public ResponseEntity<FishingSpotDto> getFishingSpotClosest(@RequestBody FishingSpotLocationCommand fishingSpotLocationCommand) {
        double lon = fishingSpotLocationCommand.longitude();
        double lat = fishingSpotLocationCommand.latitude();
        var spot = fishingSpotService.getClosestFishingSpot(lon, lat);

        if (spot != null) return new ResponseEntity<>(fishingSpotService.getClosestFishingSpot(lon, lat), HttpStatus.OK);
        else return new ResponseEntity<>(HttpStatus.NOT_FOUND);
    }

    @GetMapping("/postedIn")
    public ResponseEntity<List<FishingSpotDto>> getPostedInFishingSpots(Authentication authentication) {
        UUID currentUserId = UUID.fromString((String) authentication.getPrincipal());

        var fishingSpots = fishingSpotService.getPostedInFishingSpots(currentUserId);

        if (fishingSpots != null) return new ResponseEntity<>(fishingSpots, HttpStatus.OK);
        else return new ResponseEntity<>(HttpStatus.NOT_FOUND);
    }

    @PutMapping("/{id}")
    public ResponseEntity<FishingSpotDto> updateFishingSpot(Authentication authentication, @PathVariable UUID id, @RequestBody FishingSpotUpdateCommand fishingSpotUpdateCommand) {
        UUID currentUserId = UUID.fromString((String) authentication.getPrincipal());

        var spot = fishingSpotService.updateFishingSpot(currentUserId, id, fishingSpotUpdateCommand);

        return new ResponseEntity<>(spot, HttpStatus.OK);
    }
}
