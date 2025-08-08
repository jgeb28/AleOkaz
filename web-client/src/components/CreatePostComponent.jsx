import { useState } from "react";
import { useNavigate } from "react-router-dom";

import { fetchWithAuth } from "../services/fetchWithAuth";
import backend_url from "../services/backend";

import './CreatePostComponent.css';

export default function CreatePostComponent({ fishingSpotId }) {
    const [content, setContent] = useState("");
    const [image, setImage] = useState(null);
    const [error, setError] = useState(null);
    const [showForm, setShowForm] = useState(false);
    const navigate = useNavigate();

    const handleSubmit = async () => {
        setError(null);

        const formData = new FormData();
        formData.append("post", new Blob([JSON.stringify({
            content,
            fishingSpotId,
        })], { type: "application/json" }));
        if (image) {
            formData.append("image", image);
        }

        try {
            await fetchWithAuth(`${backend_url()}/posts`, {
                method: "POST",
                body: formData,
            }, navigate);

            window.location.reload();
        } catch (err) {
            setError(err.message || "Creating post failed");
        }
    };

    return (
        <div className="create-post-component-container">
            <div
                onClick={() => setShowForm(!showForm)}
                className="create-post-toggle"
            >
                {showForm ? "Cancel" : "Create Post"}
            </div>
            {showForm && (
                <div className="create-post-form">
                    <textarea
                        placeholder="Content"
                        value={content}
                        required
                        onChange={(e) => setContent(e.target.value)}
                        onInput={e => {
                            e.target.style.height = "auto";
                            e.target.style.height = e.target.scrollHeight + "px";
                        }}
                        className="post-content-input"
                    />
                    <label htmlFor="post-image-upload" className="post-image-label">
                        {image ? `Selected: ${image.name}` : "Choose image"}
                    </label>
                    <input
                        id="post-image-upload"
                        type="file"
                        accept="image/*"
                        onChange={(e) => {
                            setImage(e.target.files[0]);
                        }}
                        className="post-image-input"
                        style={{ display: "none" }}
                    />
                    {image && (
                        <img
                            src={URL.createObjectURL(image)}
                            alt="Preview"
                            className="post-image-preview"
                        />
                    )}
                    {error && <p className="error">{error}</p>}
                    <button onClick={() => handleSubmit()} className="post-submit-button">Create Post</button>
                </div>
            )}
        </div>
    );
}