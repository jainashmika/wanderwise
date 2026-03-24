package com.smarttravel.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.*;

// CORS = Cross-Origin Resource Sharing
// Without this, your HTML frontend (opened from a file) can't call the Java backend.
// This config tells the backend: "accept requests from any origin (our frontend)".

@Configuration
public class CorsConfig implements WebMvcConfigurer {

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/api/**")   // apply to all API routes
                .allowedOrigins("*")     // allow any frontend
                .allowedMethods("GET", "POST", "PUT", "DELETE")
                .allowedHeaders("*");
    }
}
