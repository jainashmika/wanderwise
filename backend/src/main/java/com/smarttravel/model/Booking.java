package com.smarttravel.model;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "Bookings")
public class Booking {

    // Enum for the booking lifecycle
    public enum BookingStatus { Pending, Confirmed, Cancelled }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "booking_id")
    private Integer bookingId;

    // Each booking must have a user
    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    // Hotel, Transport, Package are optional (can be null if only one is booked)
    @ManyToOne
    @JoinColumn(name = "hotel_id")
    private Hotel hotel;

    @ManyToOne
    @JoinColumn(name = "transport_id")
    private Transport transport;

    @ManyToOne
    @JoinColumn(name = "package_id")
    private BudgetPackage budgetPackage;

    @Column(name = "check_in_date")
    private LocalDate checkInDate;

    @Column(name = "check_out_date")
    private LocalDate checkOutDate;

    @Column(name = "num_people")
    private Integer numPeople;

    @Column(name = "booking_date")
    private LocalDateTime bookingDate;

    @Enumerated(EnumType.STRING)
    @Column(name = "status")
    private BookingStatus status;

    @Column(name = "total_amount", nullable = false)
    private BigDecimal totalAmount;

    @PrePersist
    protected void onCreate() {
        bookingDate = LocalDateTime.now();
        if (status == null) status = BookingStatus.Pending;
    }

    // --- Constructors ---
    public Booking() {}

    // --- Getters and Setters ---
    public Integer getBookingId()                       { return bookingId; }
    public void setBookingId(Integer bookingId)         { this.bookingId = bookingId; }
    public User getUser()                               { return user; }
    public void setUser(User user)                      { this.user = user; }
    public Hotel getHotel()                             { return hotel; }
    public void setHotel(Hotel hotel)                   { this.hotel = hotel; }
    public Transport getTransport()                     { return transport; }
    public void setTransport(Transport transport)       { this.transport = transport; }
    public BudgetPackage getBudgetPackage()             { return budgetPackage; }
    public void setBudgetPackage(BudgetPackage p)       { this.budgetPackage = p; }
    public LocalDate getCheckInDate()                   { return checkInDate; }
    public void setCheckInDate(LocalDate checkInDate)   { this.checkInDate = checkInDate; }
    public LocalDate getCheckOutDate()                  { return checkOutDate; }
    public void setCheckOutDate(LocalDate checkOutDate) { this.checkOutDate = checkOutDate; }
    public Integer getNumPeople()                       { return numPeople; }
    public void setNumPeople(Integer numPeople)         { this.numPeople = numPeople; }
    public LocalDateTime getBookingDate()               { return bookingDate; }
    public void setBookingDate(LocalDateTime bookingDate){ this.bookingDate = bookingDate; }
    public BookingStatus getStatus()                    { return status; }
    public void setStatus(BookingStatus status)         { this.status = status; }
    public BigDecimal getTotalAmount()                  { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount)  { this.totalAmount = totalAmount; }
}
