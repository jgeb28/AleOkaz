import { useState } from "react";
import { useNavigate, Link } from "react-router-dom";

import { authenticate } from "../services/fetchWithAuth";

import "./LoginComponent.css";


export default function LoginComponent() {
    const [username, setUsername] = useState("");
    const [password, setPassword] = useState("");
    const [error, setError] = useState(null);
    const navigate = useNavigate();

    const handleLogin = async () => {
        setError(null);
        try {
            await authenticate(username, password);
            navigate("/user-profile");
        } catch (err) {
            setError(err.message || "Login failed");
        }
    };

    return (
        <div className="login-component-container">
            <h1>Login</h1>
            <div className="login-form">
                <input
                    type="text"
                    placeholder="Username"
                    value={username}
                    required
                    onChange={(e) => setUsername(e.target.value)}
                    className="login-username-input"
                />
                <input
                    type="password"
                    placeholder="Password"
                    value={password}
                    required
                    onChange={(e) => setPassword(e.target.value)}
                    className="login-password-input"
                />
                {error && <p>{error}</p>}
                <button
                    onClick={() => handleLogin()}
                    className="login-button"
                >
                    Log In
                </button>
            </div>
            <div className="register-link"><Link to="/register">Don't have an account? Register here</Link></div>
        </div>
    );
}