import { useParams, useNavigate } from "react-router-dom";
import { useState, useEffect } from "react";

import FishingSpotComponent from "../components/FishingSpotComponent";
import CreatePostComponent from "../components/CreatePostComponent";
import ListPostsComponent from "../components/ListPostsComponent";

import { fetchWithAuth } from "../services/fetchWithAuth";
import backend_url from "../services/backend";

export default function FishingSpotPostsPage() {
    const { fishingSpotId } = useParams();
    const [fishingSpotPosts, setFishingSpotPosts] = useState(null);
    const [fishingSpot, setFishingSpot] = useState(null);
    const [error, setError] = useState(null);
    const navigate = useNavigate();

    useEffect(() => {
        fetchFishingSpotPosts();
        fetchFishingSpot();
    }, [fishingSpotId]);

    const fetchFishingSpotPosts = async () => {
        setError(null);
        setFishingSpotPosts(null);
        setFishingSpot(null);

        try {
            const res = await fetchWithAuth(`${backend_url()}/posts/fishing-spot/${fishingSpotId}`, {
                method: "GET",
                headers: {
                    "Content-Type": "application/json",
                }
            }, navigate);
            if (res.status === 200) {
                setFishingSpotPosts(await res.json());
            }
        } catch (err) {
            setError(err.message || "Loading fishing spot posts failed");
        }
    };

    const fetchFishingSpot = async () => {
        try {
            const res = await fetchWithAuth(`${backend_url()}/fishingspots/id/${fishingSpotId}`, {
                method: "GET",
                headers: {
                    "Content-Type": "application/json",
                }
            }, navigate);

            if (res.status === 200) {
                setFishingSpot(await res.json());
            }
        } catch (err) {
            setError(err.message || "Loading fishing spot failed");
        }
    };

    return (
        <div className="post-page-container">
            {fishingSpot && <FishingSpotComponent spot={fishingSpot} />}
            <CreatePostComponent fishingSpotId={fishingSpotId} />
            <h1>Posts from that location</h1>
            {error && <p>{error}</p>}
            {fishingSpotPosts ? (
                <ListPostsComponent posts={fishingSpotPosts} />
            ) : (
                <p>No posts to display</p>
            )}
        </div>
    );
}