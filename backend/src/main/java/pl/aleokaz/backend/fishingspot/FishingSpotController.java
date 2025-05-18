package pl.aleokaz.backend.fishingspot;

import org.apache.coyote.Response;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/fishingspot")
public class FishingSpotController {
    @Autowired
    private FishingSpotService fishingSpotService;

    @GetMapping("/all")
    public ResponseEntity<List<FishingSpotDto>> getAllFishingSpots() {
        return new ResponseEntity<>(fishingSpotService.getAllFishingSpots(), HttpStatus.OK);
    }

    @PostMapping
    public ResponseEntity<FishingSpotDto> createFishingSpot(Authentication authentication, @RequestBody FishingSpotCommand fishingSpotCommand) {
        UUID currentUserId = UUID.fromString((String) authentication.getPrincipal());

        FishingSpotDto createdFishingSpot = fishingSpotService.createFishingSpot(currentUserId, fishingSpotCommand);
        return ResponseEntity.status(HttpStatus.CREATED).body(createdFishingSpot);
    }


}
