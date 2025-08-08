import { HashRouter, Routes, Route, Link, useNavigate } from 'react-router-dom'
import { useState, useEffect } from 'react'

import LoginPage from './pages/LoginPage'
import RegisterPage from './pages/RegisterPage'
import UserProfilePage from './pages/UserProfilePage'
import FishingSpotsPage from './pages/FishingSpotsPage'
import FishingSpotPostsPage from './pages/FishingSpotPostsPage'

import { logout } from './services/fetchWithAuth'

import './App.css'

function Navbar() {
    const navigate = useNavigate();
    const [isLoggedIn, setIsLoggedIn] = useState(!!localStorage.getItem("accessToken"));

    useEffect(() => {
        const onAuthChange = () => {
            setIsLoggedIn(!!localStorage.getItem("accessToken"));
            console.log("Auth change detected, isLoggedIn:", !!localStorage.getItem("accessToken"));
        };
        window.addEventListener('authChange', onAuthChange);
        return () => {
            window.removeEventListener('authChange', onAuthChange);
        }
    }, []);

    return (
        <>
            {isLoggedIn ? (
            <nav className='navbar'>
                <Link to="/user-profile">Profile</Link>
                <Link onClick={() => logout(navigate)} to="/login">Logout</Link>
                <Link to="/fishing-spots">Fishing Spots</Link>
            </nav>
            ) : (
            <nav className='navbar'>
                <Link to="/login">Login</Link>
                <Link to="/register">Register</Link>
            </nav>
            )}
        </>
    );
}

function App() {
    return (
            <HashRouter>
                <Navbar/>
                <div className="main-page">
                <Routes>
                    <Route path="/" element={<LoginPage />} />
                    <Route path="/login" element={<LoginPage />} />
                    <Route path="/register" element={<RegisterPage />} />
                    <Route path="/user-profile" element={<UserProfilePage isMe={true} />} />
                    <Route path="/user-profile/:userIdParam" element={<UserProfilePage />} />
                    <Route path="/fishing-spots" element={<FishingSpotsPage />} />
                    <Route path="/fishing-spots/:fishingSpotId/posts" element={<FishingSpotPostsPage />} />
                </Routes>
                </div>
            </HashRouter>
    )
}

export default App
