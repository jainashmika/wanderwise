package com.smarttravel.controller;

import com.smarttravel.model.Payment;
import com.smarttravel.service.PaymentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/payments")
@CrossOrigin(origins = "*")
public class PaymentController {

    @Autowired
    private PaymentService paymentService;

    /**
     * Process a new payment
     * POST /api/payments/process
     * Body: { "bookingId": 1, "amount": 5000.00, "paymentMethod": "Credit_Card" }
     */
    @PostMapping("/process")
    public ResponseEntity<?> processPayment(@RequestBody Map<String, Object> payload) {
        try {
            if (payload.get("bookingId") == null || payload.get("amount") == null || payload.get("paymentMethod") == null) {
                return ResponseEntity.badRequest()
                    .body(new ErrorResponse("bookingId, amount, and paymentMethod are required"));
            }
            Integer bookingId = Integer.valueOf(payload.get("bookingId").toString().trim());
            BigDecimal amount = new BigDecimal(payload.get("amount").toString().trim());
            String paymentMethod = payload.get("paymentMethod").toString().trim();

            // Validate payment method
            if (!isValidPaymentMethod(paymentMethod)) {
                return ResponseEntity.badRequest()
                    .body(new ErrorResponse("Invalid payment method: " + paymentMethod));
            }

            // Validate amount
            if (!paymentService.validatePaymentAmount(bookingId, amount)) {
                return ResponseEntity.badRequest()
                    .body(new ErrorResponse("Payment amount does not match booking total"));
            }

            Payment payment = paymentService.processPayment(bookingId, amount, paymentMethod);

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("message", "Payment processed successfully");
            response.put("paymentId", payment.getPaymentId());
            response.put("transactionId", payment.getTransactionId());
            response.put("status", payment.getStatus());
            response.put("amount", payment.getAmount());

            return ResponseEntity.ok(response);

        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest()
                .body(new ErrorResponse(e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(new ErrorResponse("Payment processing failed: " + e.getMessage()));
        }
    }

    /**
     * Get payment by booking ID
     * GET /api/payments/booking/{bookingId}
     */
    @GetMapping("/booking/{bookingId}")
    public ResponseEntity<?> getPaymentByBookingId(@PathVariable Integer bookingId) {
        Optional<Payment> payment = paymentService.getPaymentByBookingId(bookingId);
        
        if (payment.isPresent()) {
            return ResponseEntity.ok(payment.get());
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                .body(new ErrorResponse("No payment found for booking ID: " + bookingId));
        }
    }

    /**
     * Get payment by transaction ID
     * GET /api/payments/transaction/{transactionId}
     */
    @GetMapping("/transaction/{transactionId}")
    public ResponseEntity<?> getPaymentByTransactionId(@PathVariable String transactionId) {
        Optional<Payment> payment = paymentService.getPaymentByTransactionId(transactionId);
        
        if (payment.isPresent()) {
            return ResponseEntity.ok(payment.get());
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                .body(new ErrorResponse("No payment found for transaction ID: " + transactionId));
        }
    }

    /**
     * Get all payments with specific status
     * GET /api/payments/status/Success
     */
    @GetMapping("/status/{status}")
    public ResponseEntity<?> getPaymentsByStatus(@PathVariable String status) {
        try {
            Payment.PaymentStatus paymentStatus = Payment.PaymentStatus.valueOf(status);
            List<Payment> payments = paymentService.getPaymentsByStatus(paymentStatus);
            return ResponseEntity.ok(payments);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest()
                .body(new ErrorResponse("Invalid payment status: " + status));
        }
    }

    /**
     * Get all payments
     * GET /api/payments/all
     */
    @GetMapping("/all")
    public ResponseEntity<?> getAllPayments() {
        List<Payment> payments = paymentService.getAllPayments();
        return ResponseEntity.ok(payments);
    }

    /**
     * Update payment status
     * PUT /api/payments/{paymentId}/status
     * Body: { "status": "Success" }
     */
    @PutMapping("/{paymentId}/status")
    public ResponseEntity<?> updatePaymentStatus(
            @PathVariable Integer paymentId,
            @RequestBody Map<String, String> payload) {
        try {
            String status = payload.get("status");
            Payment payment = paymentService.updatePaymentStatus(paymentId, status);
            return ResponseEntity.ok(payment);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest()
                .body(new ErrorResponse(e.getMessage()));
        }
    }

    /**
     * Validate if payment method is valid
     */
    private boolean isValidPaymentMethod(String method) {
        if (method == null || method.trim().isEmpty()) return false;
        String normalized = method.trim().replace(" ", "_");
        try {
            Payment.PaymentMethod.valueOf(normalized);
            return true;
        } catch (IllegalArgumentException e) {
            return false;
        }
    }

    // --- Inner class for error response ---
    public static class ErrorResponse {
        public String error;

        public ErrorResponse(String error) {
            this.error = error;
        }

        public String getError() {
            return error;
        }
    }
}
