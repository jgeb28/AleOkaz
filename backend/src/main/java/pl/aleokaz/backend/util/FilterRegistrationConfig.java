package pl.aleokaz.backend.util;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import pl.aleokaz.backend.security.JwtTokenProvider;

@Configuration
public class FilterRegistrationConfig {
    @Autowired
    JwtTokenProvider jwtTokenProvider;

    @Bean
    public FilterRegistrationBean<JwtAuthenticationFilter> jwtAuthenticationFilter() {
        FilterRegistrationBean<JwtAuthenticationFilter> filterRegistrationBean = new FilterRegistrationBean<>();
        filterRegistrationBean.setFilter(new JwtAuthenticationFilter(jwtTokenProvider));
        filterRegistrationBean.addUrlPatterns("/api/fishingspots/*", "/api/comments/*", "/api/posts/*", "/api/friends/*", "/api/sse/*", "/api/users/info/*");
        return filterRegistrationBean;
    }
}
