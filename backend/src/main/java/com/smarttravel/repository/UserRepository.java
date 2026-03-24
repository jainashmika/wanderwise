package com.smarttravel.repository;

import com.smarttravel.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

// JpaRepository<User, Integer> means:
//   - Entity type = User
//   - Primary key type = Integer (user_id)
// Spring automatically provides: save(), findById(), findAll(), deleteById() etc.
// We only need to add CUSTOM queries here.

public interface UserRepository extends JpaRepository<User, Integer> {

    // Spring reads the method name and auto-generates:
    // SELECT * FROM Users WHERE email = ?
    Optional<User> findByEmail(String email);

    // SELECT * FROM Users WHERE email = ? AND password_hash = ?
    Optional<User> findByEmailAndPasswordHash(String email, String passwordHash);

    // Checks if any user has this email (for duplicate check during registration)
    boolean existsByEmail(String email);
}
