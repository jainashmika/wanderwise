package com.smarttravel.controller;

import com.smarttravel.model.Booking;
import com.smarttravel.service.BookingService;
import java.math.BigDecimal;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/bookings")
public class BookingController {

    @Autowired
    private BookingService bookingService;

    // POST /api/bookings
    // Request body example:
    // { "userId": 1, "hotelId": 2, "transportId": 1, "checkIn": "2025-05-01",
    //   "checkOut": "2025-05-05", "numPeople": 2 }
    @PostMapping
    public ResponseEntity<Map<String, Object>> createBooking(@RequestBody Map<String, Object> body) {
        try {
            if (body.get("userId") == null || body.get("userId").toString().trim().isEmpty()) {
                Map<String, Object> response = new HashMap<>();
                response.put("message", "User ID is required");
                return ResponseEntity.badRequest().body(response);
            }
            Integer userId = Integer.valueOf(body.get("userId").toString().trim());
            Integer hotelId = (body.get("hotelId") != null && !body.get("hotelId").toString().trim().isEmpty())
                    ? Integer.valueOf(body.get("hotelId").toString().trim()) : null;
            Integer transportId = (body.get("transportId") != null && !body.get("transportId").toString().trim().isEmpty())
                    ? Integer.valueOf(body.get("transportId").toString().trim()) : null;
            Integer packageId = (body.get("packageId") != null && !body.get("packageId").toString().trim().isEmpty())
                    ? Integer.valueOf(body.get("packageId").toString().trim()) : null;

            LocalDate checkIn = null;
            if (body.get("checkIn") != null && !body.get("checkIn").toString().trim().isEmpty()) {
                checkIn = LocalDate.parse(body.get("checkIn").toString().trim());
            }
            LocalDate checkOut = null;
            if (body.get("checkOut") != null && !body.get("checkOut").toString().trim().isEmpty()) {
                checkOut = LocalDate.parse(body.get("checkOut").toString().trim());
            }

            Integer numPeople = 1;
            if (body.get("numPeople") != null && !body.get("numPeople").toString().trim().isEmpty()) {
                numPeople = Integer.valueOf(body.get("numPeople").toString().trim());
            }

            Booking booking = bookingService.createBooking(
                    userId, hotelId, transportId, packageId, checkIn, checkOut, numPeople);

            Map<String, Object> response = new HashMap<>();
            response.put("message", "BOOKING_CONFIRMED");
            response.put("bookingId", booking.getBookingId());
            response.put("totalAmount", booking.getTotalAmount());
            return ResponseEntity.ok(response);
        } catch (IllegalArgumentException e) {
            Map<String, Object> response = new HashMap<>();
            response.put("message", e.getMessage());
            return ResponseEntity.badRequest().body(response);
        } catch (Exception e) {
            Map<String, Object> response = new HashMap<>();
            response.put("message", "Booking creation failed: " + e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }

    // GET /api/bookings/all
    @GetMapping("/all")
    public List<Booking> getAllBookings() {
        return bookingService.getAllBookings();
    }

    // GET /api/bookings/user/{userId}
    @GetMapping("/user/{userId}")
    public List<Booking> getBookingsByUser(@PathVariable Integer userId) {
        return bookingService.getBookingsByUser(userId);
    }

    // PUT /api/bookings/{id}/cancel
    @PutMapping("/{id}/cancel")
    public ResponseEntity<Map<String, String>> cancelBooking(@PathVariable Integer id) {
        String result = bookingService.cancelBooking(id);
        Map<String, String> response = new HashMap<>();
        response.put("message", result);
        return ResponseEntity.ok(response);
    }

    // GET /api/bookings/reports/revenue
    @GetMapping("/reports/revenue")
    public ResponseEntity<?> getTotalRevenue() {
        Map<String, Object> response = new HashMap<>();
        response.put("totalRevenue", bookingService.getTotalRevenue());
        return ResponseEntity.ok(response);
    }

    // GET /api/bookings/reports/popular-hotels
    @GetMapping("/reports/popular-hotels")
    public List<Object[]> getPopularHotels() {
        return bookingService.getMostPopularHotels();
    }
}
