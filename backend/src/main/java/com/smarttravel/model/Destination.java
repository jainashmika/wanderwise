package com.smarttravel.model;

import jakarta.persistence.*;

// @Entity tells JPA: "This Java class maps to a database table"
// @Table tells JPA which table name to use
@Entity
@Table(name = "Destinations")
public class Destination {

    @Id                                          // marks the primary key
    @GeneratedValue(strategy = GenerationType.IDENTITY)  // AUTO_INCREMENT
    @Column(name = "destination_id")
    private Integer destinationId;

    @Column(name = "city", nullable = false)
    private String city;

    @Column(name = "country")
    private String country;

    @Column(name = "description", columnDefinition = "TEXT")
    private String description;

    @Column(name = "best_season")
    private String bestSeason;

    @Column(name = "image_url")
    private String imageUrl;

    // --- Constructors ---
    public Destination() {}

    public Destination(String city, String country, String description, String bestSeason, String imageUrl) {
        this.city = city;
        this.country = country;
        this.description = description;
        this.bestSeason = bestSeason;
        this.imageUrl = imageUrl;
    }

    // --- Getters and Setters ---
    // (Spring needs these to convert Java objects to JSON and back)
    public Integer getDestinationId()             { return destinationId; }
    public void setDestinationId(Integer id)      { this.destinationId = id; }
    public String getCity()                        { return city; }
    public void setCity(String city)               { this.city = city; }
    public String getCountry()                     { return country; }
    public void setCountry(String country)         { this.country = country; }
    public String getDescription()                 { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getBestSeason()                  { return bestSeason; }
    public void setBestSeason(String bestSeason)   { this.bestSeason = bestSeason; }
    public String getImageUrl()                    { return imageUrl; }
    public void setImageUrl(String imageUrl)       { this.imageUrl = imageUrl; }
}
