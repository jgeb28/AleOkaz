import { useEffect, useState } from "react";
import { useParams, useNavigate } from "react-router-dom";

import ListPostsComponent from "../components/ListPostsComponent";
import UserProfileComponent from "../components/UserProfileComponent";
import { fetchWithAuth } from "../services/fetchWithAuth";
import backend_url from "../services/backend";

export default function UserProfilePage() {
    const { userIdParam } = useParams();
    const [userPostItems, setUserPostItems] = useState([]);
    const [error, setError] = useState(null);
    const navigate = useNavigate();

    useEffect(() => {
        loadPosts();
    }, []);

    const loadPosts = async () => {
        setError(null);
        setUserPostItems([]);
        let url = `${backend_url()}/posts/all`;
        if (userIdParam) {
            url = `${url}?userId=${userIdParam}`;
        }
        try {
            const res = await fetchWithAuth(url, {
                method: "GET",
                headers: {
                    "Content-Type": "application/json",
                }
            }, navigate);

            if (res.status === 200) {
                setUserPostItems(await res.json());
            }
        } catch (err) {
            setError(err.message || "Loading profile failed");
        }
    };

    return (
        <div className="user-profile-page-container">
            <UserProfileComponent userId={userIdParam}/>
            <h1>User Posts</h1>
            <div>
                {error && <p>{error}</p>}
                {userPostItems.length > 0 ? (
                    <ListPostsComponent posts={userPostItems} />
                ) : (
                    <p>No posts available.</p>
                )}
            </div>
        </div>
    );
}