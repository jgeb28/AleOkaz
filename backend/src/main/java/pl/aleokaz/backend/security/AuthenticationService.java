package pl.aleokaz.backend.security;

import org.springframework.stereotype.Service;

import java.util.UUID;

import org.springframework.security.core.Authentication;

@Service
public class AuthenticationService {
    public UUID getCurrentUserId(Authentication authentication) {
        if (authentication == null || !authentication.isAuthenticated()) {
            return null;
        }
        return UUID.fromString((String) authentication.getPrincipal());
    }
}
