package com.smarttravel.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "Reviews")
public class Review {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "review_id")
    private Integer reviewId;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    // hotel_id and spot_id are both nullable — review is for one or the other
    @ManyToOne
    @JoinColumn(name = "hotel_id")
    private Hotel hotel;

    @ManyToOne
    @JoinColumn(name = "spot_id")
    private TouristSpot spot;

    @Column(name = "rating")
    private Integer rating;

    @Column(name = "comment", columnDefinition = "TEXT")
    private String comment;

    @Column(name = "review_date")
    private LocalDateTime reviewDate;

    @PrePersist
    protected void onCreate() { reviewDate = LocalDateTime.now(); }

    // --- Constructors ---
    public Review() {}

    // --- Getters and Setters ---
    public Integer getReviewId()                    { return reviewId; }
    public void setReviewId(Integer reviewId)       { this.reviewId = reviewId; }
    public User getUser()                           { return user; }
    public void setUser(User user)                  { this.user = user; }
    public Hotel getHotel()                         { return hotel; }
    public void setHotel(Hotel hotel)               { this.hotel = hotel; }
    public TouristSpot getSpot()                    { return spot; }
    public void setSpot(TouristSpot spot)           { this.spot = spot; }
    public Integer getRating()                      { return rating; }
    public void setRating(Integer rating)           { this.rating = rating; }
    public String getComment()                      { return comment; }
    public void setComment(String comment)          { this.comment = comment; }
    public LocalDateTime getReviewDate()            { return reviewDate; }
    public void setReviewDate(LocalDateTime d)      { this.reviewDate = d; }
}
