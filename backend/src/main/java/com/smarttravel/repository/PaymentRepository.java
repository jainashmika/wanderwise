package com.smarttravel.repository;

import com.smarttravel.model.Payment;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface PaymentRepository extends JpaRepository<Payment, Integer> {

    Optional<Payment> findByBooking_BookingId(Integer bookingId);
    Optional<Payment> findByTransactionId(String transactionId);
    List<Payment> findByStatus(Payment.PaymentStatus status);
}
