package com.smarttravel.service;

import com.smarttravel.model.Payment;
import com.smarttravel.model.Booking;
import com.smarttravel.repository.PaymentRepository;
import com.smarttravel.repository.BookingRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
public class PaymentService {

    @Autowired
    private PaymentRepository paymentRepository;

    @Autowired
    private BookingRepository bookingRepository;

    /**
     * Process a payment for a booking
     */
    public Payment processPayment(Integer bookingId, BigDecimal amount, 
                                   String paymentMethod) {
        Optional<Booking> booking = bookingRepository.findById(bookingId);
        
        if (!booking.isPresent()) {
            throw new IllegalArgumentException("Booking not found with ID: " + bookingId);
        }

        Payment payment = new Payment();
        payment.setBooking(booking.get());
        payment.setAmount(amount);
        payment.setPaymentMethod(Payment.PaymentMethod.valueOf(paymentMethod));
        payment.setStatus(Payment.PaymentStatus.Pending);
        payment.setTransactionId(generateTransactionId());
        payment.setPaymentDate(LocalDateTime.now());

        // Simulate payment processing (in real scenario, call payment gateway)
        payment.setStatus(Payment.PaymentStatus.Success);

        return paymentRepository.save(payment);
    }

    /**
     * Get payment by booking ID
     */
    public Optional<Payment> getPaymentByBookingId(Integer bookingId) {
        return paymentRepository.findByBooking_BookingId(bookingId);
    }

    /**
     * Get payment by transaction ID
     */
    public Optional<Payment> getPaymentByTransactionId(String transactionId) {
        return paymentRepository.findByTransactionId(transactionId);
    }

    /**
     * Get all payments with a specific status
     */
    public List<Payment> getPaymentsByStatus(Payment.PaymentStatus status) {
        return paymentRepository.findByStatus(status);
    }

    /**
     * Update payment status
     */
    public Payment updatePaymentStatus(Integer paymentId, String status) {
        Optional<Payment> payment = paymentRepository.findById(paymentId);
        
        if (!payment.isPresent()) {
            throw new IllegalArgumentException("Payment not found with ID: " + paymentId);
        }

        Payment p = payment.get();
        p.setStatus(Payment.PaymentStatus.valueOf(status));
        return paymentRepository.save(p);
    }

    /**
     * Get all payments
     */
    public List<Payment> getAllPayments() {
        return paymentRepository.findAll();
    }

    /**
     * Generate a unique transaction ID
     */
    private String generateTransactionId() {
        return "TXN-" + UUID.randomUUID().toString().substring(0, 12).toUpperCase();
    }

    /**
     * Validate payment amount against booking
     */
    public boolean validatePaymentAmount(Integer bookingId, BigDecimal amount) {
        Optional<Booking> booking = bookingRepository.findById(bookingId);
        
        if (!booking.isPresent()) {
            return false;
        }

        return booking.get().getTotalAmount().compareTo(amount) == 0;
    }
}
