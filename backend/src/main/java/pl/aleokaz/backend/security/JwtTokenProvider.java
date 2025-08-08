package pl.aleokaz.backend.security;

import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.interfaces.DecodedJWT;
import com.auth0.jwt.interfaces.JWTVerifier;

import pl.aleokaz.backend.user.User;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.util.Date;

@Component
public class JwtTokenProvider {
    @Value("${jwt.secret}")
    private String secretKey;

    @Value("${jwt.access-token.expiration}")
    private long accessTokenExpirationTime;

    @Value("${jwt.refresh-token.expiration}")
    private long refreshTokenExpirationTime;

    private Algorithm getAlgorithm() {
        return Algorithm.HMAC512(secretKey);
    }

    /**
     * Generates an access token for the given user.
     */
    public String createAccessToken(User user) {
        return JWT.create()
            .withSubject(user.id().toString())
            .withIssuedAt(new Date())
            .withClaim("token_type", "access")
            .withExpiresAt(new Date(System.currentTimeMillis() + accessTokenExpirationTime))
            .sign(getAlgorithm());
    }

    /**
     * Generates a refresh token for the given user.
     */
    public String createRefreshToken(User user) {
        return JWT.create()
            .withSubject(user.id().toString())
            .withIssuedAt(new Date())
            .withClaim("token_type", "refresh")
            .withExpiresAt(new Date(System.currentTimeMillis() + refreshTokenExpirationTime))
            .sign(getAlgorithm());
    }

    public String refreshAccessToken(String refreshToken, User user) {

        DecodedJWT decodedJWT = JWT.require(Algorithm.HMAC512(secretKey)).build().verify(refreshToken);
        String username = decodedJWT.getSubject();

        return createAccessToken(user);
    }

    /**
     * Validates the given token.
     */
    public DecodedJWT validateToken(String token) {
            JWTVerifier verifier = JWT.require(getAlgorithm()).build();
            return verifier.verify(token);
    }

    public Date getTokenExpiration(String token) {
       Algorithm algorithm = this.getAlgorithm();
       DecodedJWT decodedJWT = JWT.require(algorithm).build().verify(token);

       return decodedJWT.getExpiresAt();
    }

    /**
     * Extracts the username (subject) from the token.
     */
    public String getUserIdFromToken(String token) {
        DecodedJWT decodedJWT = JWT.require(getAlgorithm())
            .build()
            .verify(token);

        return decodedJWT.getSubject();
    }
}
