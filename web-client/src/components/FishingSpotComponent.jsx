import { useNavigate } from "react-router-dom";
import { useState } from "react";

import MiniUserComponent from "./MiniUserComponent";
import UpdateFishingSpotComponent from "./UpdateFishingSpotComponent";

import './FishingSpotComponent.css';
import { use, useEffect } from "react";

export default function FishingSpotComponent({ spot }) {
    const [showUpdateComponent, setShowUpdateComponent] = useState(false);
    const navigate = useNavigate();

    useEffect(() => {
        if (localStorage.getItem("currentUserId") === spot.ownerId) {
            setShowUpdateComponent(true);
        }
    }, []);


    const handleOpenMap = () => {
        const url = `https://www.google.com/maps/search/?api=1&query=${spot.latitude},${spot.longitude}`;
        window.open(url, "_blank");
    };

    const handleViewPosts = () => {
        navigate(`/fishing-spots/${spot.id}/posts`);
    };
    return (
        <div className="fishing-spot-component-container">
            <div className="fishing-spot-bar">
                <div className="spot-user-component"><MiniUserComponent userId={spot.ownerId} /></div>
                <div className="spot-name">{spot.name}</div>
                <div className="spot-coordinates">
                    ({spot.latitude} {spot.longitude})
                </div>
            </div>
            <div className="spot-description">{spot.description}</div>
            <div className="fishing-spot-actions">
                <div onClick={() => handleOpenMap()}>Open in map</div>
                <div onClick={() => handleViewPosts()}>View posts</div>
            </div>
            {showUpdateComponent && <UpdateFishingSpotComponent spot={spot} />}
        </div>
    );
}