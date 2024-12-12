package pl.aleokaz.backend.user;

import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.interfaces.DecodedJWT;
import com.auth0.jwt.interfaces.JWTVerifier;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.util.Date;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Component
public class JwtTokenProvider {

    @Autowired
    private UserRepository userRepository;

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
        List<String> roleNames = user.roles().stream()
            .map(UserRole::name)
            .toList();

        return JWT.create()
            .withSubject(user.id().toString())
            .withIssuedAt(new Date())
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
    public boolean validateToken(String token) {
        try {
            JWTVerifier verifier = JWT.require(getAlgorithm())
                .build();

            verifier.verify(token);
            return true;

        } catch (Exception e) {
            System.out.println("Token validation failed: " + e.getMessage());
            return false;
        }
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
