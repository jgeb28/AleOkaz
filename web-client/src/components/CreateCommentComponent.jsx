import { useState } from "react";
import { useNavigate } from "react-router-dom";

import { fetchWithAuth } from "../services/fetchWithAuth";
import backend_url from "../services/backend";

import './CreateCommentComponent.css';

export default function CreateCommentComponent({ parentId }) {
    const [content, setContent] = useState("");
    const [error, setError] = useState(null);
    const [showForm, setShowForm] = useState(false);
    const navigate = useNavigate();

    const handleSubmit = async () => {
        setError(null);

        const commentData = {
            content,
        };

        try {
            const res = await fetchWithAuth(`${backend_url()}/comments/${parentId}`, {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                },
                body: JSON.stringify(commentData),
            }, navigate);

            window.location.reload();
        } catch (err) {
            setError(err.message || "Creating comment failed");
        }
    }

    return (
        <div className="create-comment-component-container">
            <div onClick={() => setShowForm(!showForm)} className="create-comment-toggle">
                {showForm ? "Cancel" : "Reply"}
            </div>
            {showForm && <form className="create-comment-form">
                <textarea
                    type="text"
                    placeholder="Content"
                    value={content}
                    required
                    onChange={(e) => setContent(e.target.value)}
                    onInput={(e) => {
                        e.target.style.height = "auto";
                        e.target.style.height = e.target.scrollHeight + "px";
                    }}
                    className="comment-content-input" />
                <div onClick={() => handleSubmit()} className="create-comment-submit">Submit</div>
                {error && <p className="error">{error}</p>}
            </form>}
        </div>
    );
}