package com.smarttravel.model;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "Hotels")
public class Hotel {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "hotel_id")
    private Integer hotelId;

    @Column(name = "hotel_name", nullable = false)
    private String hotelName;

    // @ManyToOne = Many hotels belong to one destination (Foreign Key relationship)
    // @JoinColumn tells JPA which column in Hotels table holds the FK
    @ManyToOne
    @JoinColumn(name = "destination_id")
    private Destination destination;

    @Column(name = "address")
    private String address;

    @Column(name = "price_per_night", nullable = false)
    private BigDecimal pricePerNight;

    @Column(name = "rating")
    private BigDecimal rating;

    @Column(name = "amenities", columnDefinition = "TEXT")
    private String amenities;

    @Column(name = "available_rooms")
    private Integer availableRooms;

    // --- Constructors ---
    public Hotel() {}

    // --- Getters and Setters ---
    public Integer getHotelId()                         { return hotelId; }
    public void setHotelId(Integer hotelId)             { this.hotelId = hotelId; }
    public String getHotelName()                        { return hotelName; }
    public void setHotelName(String hotelName)          { this.hotelName = hotelName; }
    public Destination getDestination()                 { return destination; }
    public void setDestination(Destination destination) { this.destination = destination; }
    public String getAddress()                          { return address; }
    public void setAddress(String address)              { this.address = address; }
    public BigDecimal getPricePerNight()                { return pricePerNight; }
    public void setPricePerNight(BigDecimal p)          { this.pricePerNight = p; }
    public BigDecimal getRating()                       { return rating; }
    public void setRating(BigDecimal rating)            { this.rating = rating; }
    public String getAmenities()                        { return amenities; }
    public void setAmenities(String amenities)          { this.amenities = amenities; }
    public Integer getAvailableRooms()                  { return availableRooms; }
    public void setAvailableRooms(Integer availableRooms){ this.availableRooms = availableRooms; }
}
