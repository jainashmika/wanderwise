package com.smarttravel.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "Wishlist")
public class Wishlist {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "wishlist_id")
    private Integer wishlistId;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne
    @JoinColumn(name = "hotel_id")
    private Hotel hotel;

    @ManyToOne
    @JoinColumn(name = "spot_id")
    private TouristSpot spot;

    @ManyToOne
    @JoinColumn(name = "package_id")
    private BudgetPackage budgetPackage;

    @Column(name = "added_date")
    private LocalDateTime addedDate;

    @PrePersist
    protected void onCreate() { addedDate = LocalDateTime.now(); }

    // --- Constructors ---
    public Wishlist() {}

    // --- Getters and Setters ---
    public Integer getWishlistId()                      { return wishlistId; }
    public void setWishlistId(Integer wishlistId)       { this.wishlistId = wishlistId; }
    public User getUser()                               { return user; }
    public void setUser(User user)                      { this.user = user; }
    public Hotel getHotel()                             { return hotel; }
    public void setHotel(Hotel hotel)                   { this.hotel = hotel; }
    public TouristSpot getSpot()                        { return spot; }
    public void setSpot(TouristSpot spot)               { this.spot = spot; }
    public BudgetPackage getBudgetPackage()             { return budgetPackage; }
    public void setBudgetPackage(BudgetPackage p)       { this.budgetPackage = p; }
    public LocalDateTime getAddedDate()                 { return addedDate; }
    public void setAddedDate(LocalDateTime addedDate)   { this.addedDate = addedDate; }
}
