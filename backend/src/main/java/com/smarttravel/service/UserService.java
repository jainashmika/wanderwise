package com.smarttravel.service;

import com.smarttravel.model.User;
import com.smarttravel.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import java.util.Optional;

// @Service marks this as a Spring-managed service class (business logic layer)
@Service
public class UserService {

    // @Autowired = Spring injects the repository automatically (Dependency Injection)
    @Autowired
    private UserRepository userRepository;

    // BCrypt is a password hashing algorithm — one-way, very secure
    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    // ---------- REGISTER ----------
    public String register(String name, String email, String password, String phone) {
        // Check if email is already used
        if (userRepository.existsByEmail(email)) {
            return "EMAIL_EXISTS";
        }
        // Hash the password before saving (never store plain text!)
        String hashedPassword = passwordEncoder.encode(password);

        User user = new User(name, email, hashedPassword, phone);
        userRepository.save(user);
        return "SUCCESS";
    }

    // ---------- LOGIN ----------
    public Optional<User> login(String email, String password) {
        Optional<User> userOpt = userRepository.findByEmail(email);
        if (userOpt.isPresent()) {
            // passwordEncoder.matches() checks the raw password against the hash
            boolean match = passwordEncoder.matches(password, userOpt.get().getPasswordHash());
            if (match) return userOpt;
        }
        return Optional.empty(); // login failed
    }

    // ---------- GET USER BY ID ----------
    public Optional<User> getUserById(Integer id) {
        return userRepository.findById(id);
    }
}
