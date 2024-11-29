package pl.aleokaz.backend;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity
public class SecurityConfig {
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                // TODO(michalciechan): Trzeba się zastanowić nad tym, które
                // ścieżki wymagają CSRF. Wydaje mi się, że nie jest to potrzebne
                // z wyjątkiem logowania i wylogowywania.
                // https://docs.spring.io/spring-security/reference/features/exploits/csrf.html#csrf-when
                .csrf(csrf -> csrf.disable())
                .authorizeHttpRequests(authorizeHttpRequests -> authorizeHttpRequests.anyRequest().permitAll());
        return http.build();
    }
}
