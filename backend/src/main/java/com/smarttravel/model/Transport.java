package com.smarttravel.model;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalTime;

@Entity
@Table(name = "Transport")
public class Transport {

    // Java enum maps to MySQL ENUM('Bus','Train','Flight')
    public enum TransportType { Bus, Train, Flight }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "transport_id")
    private Integer transportId;

    // @Enumerated(STRING) stores "Bus"/"Train"/"Flight" as text in DB
    @Enumerated(EnumType.STRING)
    @Column(name = "type", nullable = false)
    private TransportType type;

    @Column(name = "operator_name")
    private String operatorName;

    @Column(name = "source", nullable = false)
    private String source;

    @Column(name = "destination", nullable = false)
    private String destination;

    @Column(name = "departure_time")
    private LocalTime departureTime;

    @Column(name = "arrival_time")
    private LocalTime arrivalTime;

    @Column(name = "fare", nullable = false)
    private BigDecimal fare;

    @Column(name = "available_seats")
    private Integer availableSeats;

    // --- Constructors ---
    public Transport() {}

    // --- Getters and Setters ---
    public Integer getTransportId()                     { return transportId; }
    public void setTransportId(Integer transportId)     { this.transportId = transportId; }
    public TransportType getType()                      { return type; }
    public void setType(TransportType type)             { this.type = type; }
    public String getOperatorName()                     { return operatorName; }
    public void setOperatorName(String operatorName)    { this.operatorName = operatorName; }
    public String getSource()                           { return source; }
    public void setSource(String source)                { this.source = source; }
    public String getDestination()                      { return destination; }
    public void setDestination(String destination)      { this.destination = destination; }
    public LocalTime getDepartureTime()                 { return departureTime; }
    public void setDepartureTime(LocalTime departureTime){ this.departureTime = departureTime; }
    public LocalTime getArrivalTime()                   { return arrivalTime; }
    public void setArrivalTime(LocalTime arrivalTime)   { this.arrivalTime = arrivalTime; }
    public BigDecimal getFare()                         { return fare; }
    public void setFare(BigDecimal fare)                { this.fare = fare; }
    public Integer getAvailableSeats()                  { return availableSeats; }
    public void setAvailableSeats(Integer availableSeats){ this.availableSeats = availableSeats; }
}
