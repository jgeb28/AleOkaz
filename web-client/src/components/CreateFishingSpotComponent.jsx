import { useState } from "react";
import { useNavigate } from "react-router-dom";

import { fetchWithAuth } from "../services/fetchWithAuth";
import backend_url from "../services/backend";

import './CreateFishingSpotComponent.css';

export default function CreateFishingSpotComponent() {
    const [name, setName] = useState("");
    const [description, setDescription] = useState("");
    const [latitude, setLatitude] = useState("");
    const [longitude, setLongitude] = useState("");
    const [error, setError] = useState(null);
    const [showForm, setShowForm] = useState(false);
    const navigate = useNavigate();

    const handleSubmit = async () => {
        setError(null);

        const formData = new FormData();
        formData.append("name", name);
        formData.append("description", description);
        formData.append("latitude", latitude);
        formData.append("longitude", longitude);

        try {
            const res = await fetchWithAuth(`${backend_url()}/fishingspots`, {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                },
                body: JSON.stringify({
                    name,
                    description,
                    latitude: parseFloat(latitude),
                    longitude: parseFloat(longitude),
                }),
            }, navigate);

            window.location.reload();
        } catch (err) {
            setError(err.message || "Creating fishing spot failed");
        }
    }

    return (
        <div className="create-fishing-spot-component-container">
            <div
                onClick={() => setShowForm(!showForm)}
                className="create-fishing-spot-toggle"
            >
                {showForm ? "Cancel" : "Create Spot"}
            </div>
            {showForm && (
                <div className="create-fishing-spot-form">
                    <input
                        type="text"
                        placeholder="Spot Name"
                        value={name}
                        required
                        onChange={(e) => setName(e.target.value)}
                        className="fishing-spot-name-input"
                    />
                    <textarea
                        placeholder="Description"
                        value={description}
                        required
                        onChange={(e) => setDescription(e.target.value)}
                        onInput={(e) => {
                            e.target.style.height = "auto";
                            e.target.style.height = e.target.scrollHeight + "px";
                        }}
                        className="fishing-spot-description-input"
                    />
                    <div className="fishing-spot-coordinates-inputs">
                        <input
                            type="text"
                            placeholder="Latitude"
                            value={latitude}
                            required
                            onChange={(e) => setLatitude(e.target.value)}
                            className="fishing-spot-latitude-input"
                        />
                        <input
                            type="text"
                            placeholder="Longitude"
                            value={longitude}
                            required
                            onChange={(e) => setLongitude(e.target.value)}
                            className="fishing-spot-longitude-input"
                        />
                    </div>
                    {error && <p className="error">{error}</p>}
                    <button
                        onClick={() => handleSubmit()}
                        type="submit"
                        className="fishing-spot-submit-button"
                    >
                        Create Spot
                    </button>
                </div>
            )}
        </div>
    );
}