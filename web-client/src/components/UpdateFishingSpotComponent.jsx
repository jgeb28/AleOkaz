import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { fetchWithAuth } from '../services/fetchWithAuth';
import backend_url from '../services/backend';

import './UpdateFishingSpotComponent.css';

export default function UpdateFishingSpotComponent({ spot }) {
    const [name, setName] = useState(spot.name);
    const [description, setDescription] = useState(spot.description);
    const [latitude, setLatitude] = useState(spot.latitude);
    const [longitude, setLongitude] = useState(spot.longitude);
    const [showForm, setShowForm] = useState(false);
    const [error, setError] = useState(null);
    const navigate = useNavigate();

    const updateFishingSpot = async () => {
        setError(null);

        const updatedSpot = {
            name,
            description,
            latitude,
            longitude,
        };

        try {
            const res = await fetchWithAuth(`${backend_url()}/fishingspots/${spot.id}`, {
                method: "PUT",
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(updatedSpot),
            }, navigate);

            if (res.status === 200) {
                window.location.reload();
            }
        } catch (err) {
            setError(err.message || "Updating fishing spot failed");
        }
    }

    return (
        <div className="update-fishing-spot-component-container">
            <div
                onClick={() => setShowForm(!showForm)}
                className="update-fishing-spot-toggle"
            >
                {showForm ? "Cancel" : "Update Spot"}
            </div>
            {showForm && <div className="update-fishing-spot-form">
                <input
                    type="text"
                    placeholder="Spot Name"
                    value={name}
                    onChange={(e) => setName(e.target.value)}
                    className="update-fishing-spot-name-input"
                />
                <textarea
                    placeholder="Description"
                    value={description}
                    onChange={(e) => setDescription(e.target.value)}
                    onInput={(e) =>{
                        e.target.style.height = "auto";
                        e.target.style.height = `${e.target.scrollHeight}px`
                    }} 
                    className="update-fishing-spot-description-input"
                />
                <div className="fishing-spot-coordinates-input">
                    <input
                        type="text"
                        placeholder="Latitude"
                        value={latitude}
                        onChange={(e) => setLatitude(e.target.value)}
                        className="fishing-spot-latitude-input"
                    />
                    <input
                        type="text"
                        placeholder="Longitude"
                        value={longitude}
                        onChange={(e) => setLongitude(e.target.value)}
                        className="fishing-spot-longitude-input"
                    />
                </div>
                {error && <p>{error}</p>}
                <button onClick={updateFishingSpot} className="fishing-spot-submit-button">Update Spot</button>
            </div>}
        </div>
    );
}