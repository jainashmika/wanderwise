package com.smarttravel.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.sql.DataSource;
import java.sql.Connection;
import java.time.Instant;
import java.util.HashMap;
import java.util.Map;

/**
 * Health Check Controller
 * Endpoints for Render health checks, UptimeRobot, and monitoring services.
 */
@RestController
public class HealthController {

    @Autowired(required = false)
    private DataSource dataSource;

    @GetMapping({"/healthz", "/health", "/api/healthz", "/api/health"})
    public ResponseEntity<Map<String, Object>> healthCheck() {
        Map<String, Object> health = new HashMap<>();
        health.put("status", "UP");
        health.put("service", "WanderWise - Smart Travel Planner");
        health.put("timestamp", Instant.now().toString());

        boolean dbOk = false;
        if (dataSource != null) {
            try (Connection conn = dataSource.getConnection()) {
                dbOk = conn.isValid(2);
            } catch (Exception e) {
                dbOk = false;
            }
        }
        health.put("database", dbOk ? "CONNECTED" : "DISCONNECTED_OR_MOCKED");

        return ResponseEntity.ok(health);
    }
}
