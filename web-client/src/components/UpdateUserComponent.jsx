import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { fetchWithAuth } from '../services/fetchWithAuth';
import backend_url from '../services/backend';

import './UpdateUserComponent.css';

export default function UpdateUserComponent({ user }) {
    const [username, setUsername] = useState("");
    const [image, setImage] = useState(null);
    const [showForm, setShowForm] = useState(false);
    const [error, setError] = useState(null);
    const navigate = useNavigate();

    const updateUserInfo = async () => {
        setError(null);

        const formData = new FormData();
        if (!username) {
            setUsername(user.username);
        }
        formData.append("userInfo", new Blob([JSON.stringify({ username })], { type: "application/json" }));
        if (image) {
            formData.append("image", image);
        }

        try {
            const res = await fetchWithAuth(`${backend_url()}/users/info`, {
                method: "PUT",
                body: formData,
            }, navigate);

            if (res.status === 200) {
                window.location.reload();
            }
        } catch (err) {
            setError(err.message || "Updating user info failed");
        }
    }

    return (
        <>
            <div className="update-user-component-container">
                <div
                    onClick={() => setShowForm(!showForm)}
                    className="update-user-toggle"
                >
                    {showForm ? "Cancel" : "Update Profile"}
                </div>
                {user && showForm &&
                    <div className="update-user-form">
                        <input
                            className="update-username-input"
                            type="text"
                            placeholder="Username"
                            value={username || user.username}
                            onChange={(e) => setUsername(e.target.value)}
                        />
                        <label htmlFor="update-profile-picture-input" className="user-image-label">
                            {image ? `Selected: ${image.name}` : "Choose image"}
                        </label>
                        <input
                            id="update-profile-picture-input"
                            type="file"
                            accept="image/*"
                            onChange={(e) => setImage(e.target.files[0])}
                            style={{ display: 'none' }}
                        />
                        {error && <p className="error">{error}</p>}
                        <button className="update-user-confirm-button" onClick={() => updateUserInfo()}>Update Profile</button>
                    </div>}
            </div>
        </>
    );
}