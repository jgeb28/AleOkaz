package pl.aleokaz.backend.fishingspot;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.UUID;

public interface FishingSpotRepository extends JpaRepository<FishingSpot, UUID> {
    @Query(value = """
                    SELECT *
                    FROM fishing_spot
                    ORDER BY location <-> ST_SetSRID(ST_MakePoint(:lon, :lat), 4326)
            """, nativeQuery = true)
    List<FishingSpot> getSortedByDistance(@Param("lon") double lon, @Param("lat") double lat);

    @Query(value = """
                    SELECT DISTINCT fs
                    FROM FishingSpot fs
                    JOIN fs.posts p
                    WHERE p.author.id = :userId
            """)
    List<FishingSpot> findByUserPosts(@Param("userId") UUID userId);
}
