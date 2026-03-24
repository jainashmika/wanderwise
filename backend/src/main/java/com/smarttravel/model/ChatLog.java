package com.smarttravel.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "ChatLogs")
public class ChatLog {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "chat_id")
    private Integer chatId;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    @Column(name = "message", columnDefinition = "TEXT", nullable = false)
    private String message;

    @Column(name = "response", columnDefinition = "TEXT")
    private String response;

    @Column(name = "timestamp")
    private LocalDateTime timestamp;

    @PrePersist
    protected void onCreate() { timestamp = LocalDateTime.now(); }

    // --- Constructors ---
    public ChatLog() {}

    public ChatLog(User user, String message, String response) {
        this.user = user;
        this.message = message;
        this.response = response;
    }

    // --- Getters and Setters ---
    public Integer getChatId()                      { return chatId; }
    public void setChatId(Integer chatId)           { this.chatId = chatId; }
    public User getUser()                           { return user; }
    public void setUser(User user)                  { this.user = user; }
    public String getMessage()                      { return message; }
    public void setMessage(String message)          { this.message = message; }
    public String getResponse()                     { return response; }
    public void setResponse(String response)        { this.response = response; }
    public LocalDateTime getTimestamp()             { return timestamp; }
    public void setTimestamp(LocalDateTime t)       { this.timestamp = t; }
}
