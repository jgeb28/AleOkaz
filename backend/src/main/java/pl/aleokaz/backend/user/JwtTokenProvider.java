package pl.aleokaz.backend.user;

import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.interfaces.DecodedJWT;
import com.auth0.jwt.interfaces.JWTVerifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.util.Date;
import java.util.List;

@Component
public class JwtTokenProvider {

    @Value("${jwt.secret}")
    private String secretKey;

    @Value("${jwt.expiration}")
    private long expirationTime;

    //TODO roles
    public String createToken(User user) {
        Algorithm algorithm = Algorithm.HMAC512(secretKey);

        return JWT.create()
            .withSubject(user.username())
            .withIssuedAt(new Date())
            .withExpiresAt(new Date(System.currentTimeMillis() + expirationTime))
            .sign(algorithm);
    }

    public boolean validateToken(String token) {

        try {
            Algorithm algorithm = Algorithm.HMAC512(secretKey);

            JWTVerifier verifier = JWT.require(algorithm)
                .build();

            verifier.verify(token);
            return true;

        } catch (Exception e) {
            System.out.println(e.getMessage());
            return false;
        }
    }

    public String getUsernameFromToken(String token) {
        Algorithm algorithm = Algorithm.HMAC512(secretKey);

        DecodedJWT decodedJWT = JWT.require(algorithm)
            .build()
            .verify(token);

        return decodedJWT.getSubject();
    }

    //TODO roles
    public List<String> getRolesFromToken(String token) {
        Algorithm algorithm = Algorithm.HMAC512(secretKey);

        DecodedJWT decodedJWT = JWT.require(algorithm)
            .build()
            .verify(token);

        return decodedJWT.getClaim("roles").asList(String.class);
    }
}
