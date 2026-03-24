package com.smarttravel.controller;

import com.smarttravel.model.Booking;
import com.smarttravel.service.BookingService;
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
    public ResponseEntity<Map<String, String>> createBooking(@RequestBody Map<String, Object> body) {
        Integer userId       = (Integer) body.get("userId");
        Integer hotelId      = (Integer) body.get("hotelId");
        Integer transportId  = (Integer) body.get("transportId");
        Integer packageId    = (Integer) body.get("packageId");
        LocalDate checkIn    = LocalDate.parse((String) body.get("checkIn"));
        LocalDate checkOut   = LocalDate.parse((String) body.get("checkOut"));
        Integer numPeople    = (Integer) body.getOrDefault("numPeople", 1);

        String result = bookingService.createBooking(
                userId, hotelId, transportId, packageId, checkIn, checkOut, numPeople);

        Map<String, String> response = new HashMap<>();
        response.put("message", result);
        return result.equals("BOOKING_CONFIRMED")
                ? ResponseEntity.ok(response)
                : ResponseEntity.badRequest().body(response);
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
