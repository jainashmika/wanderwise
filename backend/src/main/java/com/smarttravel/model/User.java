package com.smarttravel.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "Users")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_id")
    private Integer userId;

    @Column(name = "name", nullable = false)
    private String name;

    // unique = true enforces the UNIQUE constraint at JPA level too
    @Column(name = "email", nullable = false, unique = true)
    private String email;

    // We store HASHED password, never plain text
    @Column(name = "password_hash", nullable = false)
    private String passwordHash;

    @Column(name = "phone")
    private String phone;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    // Sets createdAt automatically before saving to DB
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }

    // --- Constructors ---
    public User() {}

    public User(String name, String email, String passwordHash, String phone) {
        this.name = name;
        this.email = email;
        this.passwordHash = passwordHash;
        this.phone = phone;
    }

    // --- Getters and Setters ---
    public Integer getUserId()                      { return userId; }
    public void setUserId(Integer userId)           { this.userId = userId; }
    public String getName()                         { return name; }
    public void setName(String name)               { this.name = name; }
    public String getEmail()                        { return email; }
    public void setEmail(String email)             { this.email = email; }
    public String getPasswordHash()                 { return passwordHash; }
    public void setPasswordHash(String passwordHash){ this.passwordHash = passwordHash; }
    public String getPhone()                        { return phone; }
    public void setPhone(String phone)             { this.phone = phone; }
    public LocalDateTime getCreatedAt()             { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt){ this.createdAt = createdAt; }
}
