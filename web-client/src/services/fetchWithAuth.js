import backend_url from "./backend";

export async function fetchWithAuth(url, options = {}, navigate) {
    let accessToken = localStorage.getItem("accessToken");
    let refreshToken = localStorage.getItem("refreshToken");

    let opts = { ...options };
    opts.headers = {
        ...(opts.headers || {}),
        "Authorization": `Bearer ${accessToken}`,
        //"Content-Type": opts.headers?.["Content-Type"] || "application/json",
    };

    let res = await fetch(url, opts);

    if (res.status < 400) {
        return res;
    }
    if (res.status !== 401) {
        const errData = await res.json();
        throw new Error(errData.message || errData.error || "Request failed");
    }

    const refreshRes = await fetch(`${backend_url()}/users/refresh`, {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
        },
        body: JSON.stringify({ refreshToken }),
    });

    if (!refreshRes.ok) {
        logout(navigate);
        return;
    }

    const refreshData = await refreshRes.json();
    localStorage.setItem("accessToken", refreshData.accessToken);

    opts.headers["Authorization"] = `Bearer ${refreshData.accessToken}`;
    return fetch(url, opts);
}


export async function authenticate(username, password) {
    const res = await fetch(`${backend_url()}/users/login`, {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
        },
        body: JSON.stringify({ username, password }),
    });

    if (!res.ok) {
        throw new Error("Authentication failed");
    }

    const data = await res.json();
    localStorage.setItem("accessToken", data.accessToken);
    localStorage.setItem("refreshToken", data.refreshToken);
    window.dispatchEvent(new Event('authChange'));

    const user = await fetchWithAuth(`${backend_url()}/users/info`, {
        method: "GET",
        headers: {
            "Content-Type": "application/json",
        }
    });
    if (user.status === 200) {
        localStorage.setItem("currentUserId", (await user.json()).id);
    } else {
        throw new Error("Failed to fetch user info");
    }
}

export async function logout(navigate) {
    localStorage.removeItem("accessToken");
    localStorage.removeItem("refreshToken");
    localStorage.removeItem("currentUserId");
    window.dispatchEvent(new Event('authChange'));
    navigate("/login");
}
