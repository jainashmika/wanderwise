package com.smarttravel.model;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "BudgetPackages")
public class BudgetPackage {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "package_id")
    private Integer packageId;

    @Column(name = "package_name", nullable = false)
    private String packageName;

    @ManyToOne
    @JoinColumn(name = "destination_id")
    private Destination destination;

    @Column(name = "total_cost", nullable = false)
    private BigDecimal totalCost;

    @Column(name = "duration_days", nullable = false)
    private Integer durationDays;

    @Column(name = "description", columnDefinition = "TEXT")
    private String description;

    @Column(name = "max_people")
    private Integer maxPeople;

    // --- Constructors ---
    public BudgetPackage() {}

    // --- Getters and Setters ---
    public Integer getPackageId()                       { return packageId; }
    public void setPackageId(Integer packageId)         { this.packageId = packageId; }
    public String getPackageName()                      { return packageName; }
    public void setPackageName(String packageName)      { this.packageName = packageName; }
    public Destination getDestination()                 { return destination; }
    public void setDestination(Destination destination) { this.destination = destination; }
    public BigDecimal getTotalCost()                    { return totalCost; }
    public void setTotalCost(BigDecimal totalCost)      { this.totalCost = totalCost; }
    public Integer getDurationDays()                    { return durationDays; }
    public void setDurationDays(Integer durationDays)   { this.durationDays = durationDays; }
    public String getDescription()                      { return description; }
    public void setDescription(String description)      { this.description = description; }
    public Integer getMaxPeople()                       { return maxPeople; }
    public void setMaxPeople(Integer maxPeople)         { this.maxPeople = maxPeople; }
}
