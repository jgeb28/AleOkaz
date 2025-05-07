package pl.aleokaz.backend.filter;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import pl.aleokaz.backend.user.JwtTokenProvider;

@Configuration
public class FilterRegistrationConfig {
    @Autowired
    JwtTokenProvider jwtTokenProvider;

    @Bean
    public FilterRegistrationBean<JwtAuthenticationFilter> jwtAuthenticationFilter() {
        FilterRegistrationBean<JwtAuthenticationFilter> filterRegistrationBean = new FilterRegistrationBean<>();
        filterRegistrationBean.setFilter(new JwtAuthenticationFilter(jwtTokenProvider));
        filterRegistrationBean.addUrlPatterns("/api/comments/*", "/api/posts/*", "/api/friends/*", "/api/sse/*");
        return filterRegistrationBean;
    }
}
