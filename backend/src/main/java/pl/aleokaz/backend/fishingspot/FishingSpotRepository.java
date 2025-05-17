package pl.aleokaz.backend.fishingspot;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface FishingSpotRepository extends JpaRepository<FishingSpot, UUID> {
}
