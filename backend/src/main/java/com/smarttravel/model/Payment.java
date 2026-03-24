package com.smarttravel.model;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "Payments")
public class Payment {

    public enum PaymentMethod { Credit_Card, Debit_Card, UPI, Net_Banking }
    public enum PaymentStatus { Success, Failed, Pending }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "payment_id")
    private Integer paymentId;

    @ManyToOne
    @JoinColumn(name = "booking_id", nullable = false)
    private Booking booking;

    @Column(name = "payment_date")
    private LocalDateTime paymentDate;

    @Column(name = "amount", nullable = false)
    private BigDecimal amount;

    @Enumerated(EnumType.STRING)
    @Column(name = "payment_method", nullable = false)
    private PaymentMethod paymentMethod;

    @Enumerated(EnumType.STRING)
    @Column(name = "status")
    private PaymentStatus status;

    @Column(name = "transaction_id", unique = true)
    private String transactionId;

    @PrePersist
    protected void onCreate() {
        paymentDate = LocalDateTime.now();
        if (status == null) status = PaymentStatus.Pending;
    }

    // --- Constructors ---
    public Payment() {}

    // --- Getters and Setters ---
    public Integer getPaymentId()                       { return paymentId; }
    public void setPaymentId(Integer paymentId)         { this.paymentId = paymentId; }
    public Booking getBooking()                         { return booking; }
    public void setBooking(Booking booking)             { this.booking = booking; }
    public LocalDateTime getPaymentDate()               { return paymentDate; }
    public void setPaymentDate(LocalDateTime paymentDate){ this.paymentDate = paymentDate; }
    public BigDecimal getAmount()                       { return amount; }
    public void setAmount(BigDecimal amount)            { this.amount = amount; }
    public PaymentMethod getPaymentMethod()             { return paymentMethod; }
    public void setPaymentMethod(PaymentMethod m)       { this.paymentMethod = m; }
    public PaymentStatus getStatus()                    { return status; }
    public void setStatus(PaymentStatus status)         { this.status = status; }
    public String getTransactionId()                    { return transactionId; }
    public void setTransactionId(String transactionId)  { this.transactionId = transactionId; }
}
