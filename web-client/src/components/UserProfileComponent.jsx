import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";

import UpdateUserComponent from "./UpdateUserComponent";

import { fetchWithAuth } from "../services/fetchWithAuth";
import backend_url from "../services/backend";

import './UserProfileComponent.css';

export default function UserProfileComponent({ userId }) {
    const [user, setUser] = useState(null);
    const [error, setError] = useState(null);
    const navigate = useNavigate();

    useEffect(() => {
        loadUserInfo();
    }, [userId]);

    const loadUserInfo = async () => {
        setError(null);
        setUser(null);

        let url = `${backend_url()}/users/info`;
        if (userId) {
            url = `${url}/${userId}`;
        }

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
        <>
            {user &&
                <div className="user-profile-component-container">
                    <h1>User Profile</h1>
                    {error && <p className="error">{error}</p>}
                    <div className="user-profile-details">
                        <h2>Profile Details</h2>
                        <p>Username: {user.username}</p>
                        <img src={backend_url().slice(0,-4)+user.profilePicture.slice(21)} alt="Profile" className="user-profile-picture" />
                        <UpdateUserComponent user={user} />
                    </div>
                </div>}
        </>
    );
}
