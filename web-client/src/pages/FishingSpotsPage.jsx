import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";

import FishingSpotComponent from "../components/FishingSpotComponent";
import CreateFishingSpotComponent from "../components/CreateFishingSpotComponent";
import { fetchWithAuth } from "../services/fetchWithAuth";
import backend_url from "../services/backend";

export default function FishingSpotsPage() {
    const [fishingSpotItems, setFishingSpotItems] = useState(null);
    const [error, setError] = useState(null);
    const navigate = useNavigate();

    useEffect(() => {
        fetchFishingSpots();
    }, []);

    const fetchFishingSpots = async () => {
        setError(null);
        setFishingSpotItems(null);

        try {
            const res = await fetchWithAuth(`${backend_url()}/fishingspots/all`, {
                method: "GET",
                headers: {
                    "Content-Type": "application/json",
                }
            }, navigate);

            if (res.status === 200) {
                setFishingSpotItems(await res.json());
            }
        } catch (err) {
            setError(err.message || "Loading fishing spots failed");
        }
    }

    return (
        <div className="fishing-spots-page-container">
            <CreateFishingSpotComponent />
            <h1>Fishing Spots</h1>
            {error && <p>{error}</p>}
            {fishingSpotItems && fishingSpotItems.map((spot) => (
                <FishingSpotComponent spot={spot} key={spot.id} />
            ))}
        </div>
    );
}