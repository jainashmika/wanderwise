package com.smarttravel.controller;

import com.smarttravel.model.User;
import com.smarttravel.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

// @RestController = @Controller + @ResponseBody (auto-converts Java objects to JSON)
// @RequestMapping sets the base URL for all methods in this class
@RestController
@RequestMapping("/api/users")
public class UserController {

    @Autowired
    private UserService userService;

    // POST /api/users/register
    // @RequestBody reads JSON from the request body into a Map
    @PostMapping("/register")
    public ResponseEntity<Map<String, String>> register(@RequestBody Map<String, String> body) {
        String result = userService.register(
                body.get("name"),
                body.get("email"),
                body.get("password"),
                body.get("phone")
        );

        Map<String, String> response = new HashMap<>();
        if (result.equals("SUCCESS")) {
            response.put("message", "Registration successful!");
            return ResponseEntity.ok(response);                  // 200 OK
        } else {
            response.put("message", "Email already registered.");
            return ResponseEntity.badRequest().body(response);   // 400 Bad Request
        }
    }

    // POST /api/users/login
    @PostMapping("/login")
    public ResponseEntity<Map<String, Object>> login(@RequestBody Map<String, String> body) {
        Optional<User> userOpt = userService.login(body.get("email"), body.get("password"));

        Map<String, Object> response = new HashMap<>();
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            response.put("message", "Login successful!");
            response.put("userId", user.getUserId());
            response.put("name", user.getName());
            response.put("email", user.getEmail());
            return ResponseEntity.ok(response);
        } else {
            response.put("message", "Invalid email or password.");
            return ResponseEntity.status(401).body(response);    // 401 Unauthorized
        }
    }

    // GET /api/users/{id}
    @GetMapping("/{id}")
    public ResponseEntity<?> getUserById(@PathVariable Integer id) {
        Optional<User> user = userService.getUserById(id);
        if (user.isPresent()) {
            // Don't return password hash to frontend
            Map<String, Object> response = new HashMap<>();
            response.put("userId", user.get().getUserId());
            response.put("name", user.get().getName());
            response.put("email", user.get().getEmail());
            response.put("phone", user.get().getPhone());
            return ResponseEntity.ok(response);
        }
        return ResponseEntity.notFound().build();               // 404
    }
}
