package pl.aleokaz.backend.user;

import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.interfaces.DecodedJWT;
import org.springframework.stereotype.Component;

import java.util.Date;

@Component
public class JwtTokenProvider {

    private static final String SECRET_KEY = "verysecretkeyyes";

    public String createToken(User user) {
        Algorithm algorithm = Algorithm.HMAC512(SECRET_KEY);

        return JWT.create()
            .withSubject(user.username())
            .withIssuedAt(new Date())
            .withExpiresAt(new Date(System.currentTimeMillis() + 3600000))
            .sign(algorithm);
    }

    public boolean validateToken(String token) {
        try {
            Algorithm algorithm = Algorithm.HMAC512(SECRET_KEY);

            DecodedJWT decodedJWT = JWT.require(algorithm)
                .build()
                .verify(token);

            return true;
        } catch (Exception e) {
            return false;
        }
    }

    public String getUsernameFromToken(String token) {
        try {
            Algorithm algorithm = Algorithm.HMAC512(SECRET_KEY);

            DecodedJWT decodedJWT = JWT.require(algorithm)
                .build()
                .verify(token);

            return decodedJWT.getSubject();
        } catch (Exception e) {
            return null;
        }
    }
}
