package com.smarttravel.model;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "TouristSpots")
public class TouristSpot {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "spot_id")
    private Integer spotId;

    @Column(name = "spot_name", nullable = false)
    private String spotName;

    @ManyToOne
    @JoinColumn(name = "destination_id")
    private Destination destination;

    @Column(name = "description", columnDefinition = "TEXT")
    private String description;

    @Column(name = "entry_fee")
    private BigDecimal entryFee;

    @Column(name = "opening_hours")
    private String openingHours;

    @Column(name = "category")
    private String category;

    // --- Constructors ---
    public TouristSpot() {}

    // --- Getters and Setters ---
    public Integer getSpotId()                          { return spotId; }
    public void setSpotId(Integer spotId)               { this.spotId = spotId; }
    public String getSpotName()                         { return spotName; }
    public void setSpotName(String spotName)            { this.spotName = spotName; }
    public Destination getDestination()                 { return destination; }
    public void setDestination(Destination destination) { this.destination = destination; }
    public String getDescription()                      { return description; }
    public void setDescription(String description)      { this.description = description; }
    public BigDecimal getEntryFee()                     { return entryFee; }
    public void setEntryFee(BigDecimal entryFee)        { this.entryFee = entryFee; }
    public String getOpeningHours()                     { return openingHours; }
    public void setOpeningHours(String openingHours)    { this.openingHours = openingHours; }
    public String getCategory()                         { return category; }
    public void setCategory(String category)            { this.category = category; }
}
