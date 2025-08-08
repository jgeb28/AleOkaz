import { useState } from "react";
import { useNavigate, Link } from "react-router-dom";

import backend_url from "../services/backend";

import "./RegisterComponent.css";

export default function RegisterComponent() {
    const [username, setUsername] = useState("");
    const [password, setPassword] = useState("");
    const [error, setError] = useState(null);
    const navigate = useNavigate();

    const registerUser = async () => {
        try {
            const res = await fetch(`${backend_url()}/users/register`, {
                method: "POST",
                headers: {
                    "Content-Type": "application/json",
                },
                body: JSON.stringify({ username, password }),
            });
            navigate("/login");
        } catch (err) {
            setError(err.message || "Registration failed");
        }
    };

    return (
        <div className="register-component-container">
            <h1>Register</h1>
            <div className="register-form">
                <input
                    type="text"
                    placeholder="Username"
                    value={username}
                    required
                    onChange={(e) => setUsername(e.target.value)}
                    className="register-username-input"
                />
                <input
                    type="password"
                    placeholder="Password"
                    value={password}
                    required
                    onChange={(e) => setPassword(e.target.value)}
                    className="register-password-input"
                />
                {error && <p className="text-red-600">{error}</p>}
                <button
                    type="submit"
                    className="register-button"
                    onClick={() => registerUser()}
                >
                    Register
                </button>
            </div>
            <div className="login-link"><Link to="/login">Already have an account? Log in here</Link></div>
        </div>
    );
}