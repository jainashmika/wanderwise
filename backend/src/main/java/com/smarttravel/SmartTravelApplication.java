package com.smarttravel;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

// @SpringBootApplication tells Spring Boot: "This is the starting point of the app"
// It automatically scans all classes in this package and sub-packages
@SpringBootApplication
public class SmartTravelApplication {

    public static void main(String[] args) {
        // This line starts the embedded web server (Tomcat) on port 8080
        SpringApplication.run(SmartTravelApplication.class, args);
        System.out.println("Smart Travel Planner is running at http://localhost:8080");
    }
}
