import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";

import { fetchWithAuth } from "../services/fetchWithAuth";
import backend_url from "../services/backend";

import './MiniUserComponent.css';

export default function MiniUserComponent({ userId }) {
    const [user, setUser] = useState(null);
    const [error, setError] = useState(null);
    const navigate = useNavigate();

    useEffect(() => {
        loadUserInfo();
    }, []);

    const loadUserInfo = async () => {
        setError(null);
        setUser(null);

        let url = `${backend_url()}/users/info/${userId}`;
        try {
            const res = await fetchWithAuth(url, {
                method: "GET",
                headers: {
                    "Content-Type": "application/json",
                }
            }, navigate);

            if (res.status === 200) {
                setUser(await res.json());
            }
        } catch (err) {
            setError(err.message || "Loading profile failed");
        }
    };

    return (
        <div className="mini-user-component-container"
            onClick={() => navigate(`/user-profile/${userId}`)}>
            {user && (<>
                <img
                    src={backend_url().slice(0,-4)+user.profilePicture.slice(21)}
                    alt="Profile"
                    className="profile-picture"
                />
            <span className="username">{user.username}</span></>)}
        </div>
    );
}
