package com.smarttravel.repository;

import com.smarttravel.model.Booking;
import com.smarttravel.model.Booking.BookingStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.math.BigDecimal;
import java.util.List;

public interface BookingRepository extends JpaRepository<Booking, Integer> {

    // Get all bookings by a specific user
    List<Booking> findByUser_UserId(Integer userId);

    // Get bookings by status
    List<Booking> findByStatus(BookingStatus status);

    // Total revenue from confirmed bookings (aggregate function)
    @Query("SELECT SUM(b.totalAmount) FROM Booking b WHERE b.status = 'Confirmed'")
    BigDecimal getTotalRevenue();

    // Count bookings per user
    @Query("SELECT b.user.name, COUNT(b) FROM Booking b GROUP BY b.user.name")
    List<Object[]> countBookingsPerUser();

    // Most popular hotel
    @Query("SELECT b.hotel.hotelName, COUNT(b) as cnt FROM Booking b WHERE b.hotel IS NOT NULL GROUP BY b.hotel.hotelName ORDER BY cnt DESC")
    List<Object[]> getMostPopularHotels();

    // Bookings for a specific hotel
    List<Booking> findByHotel_HotelId(Integer hotelId);

    // Find by user and status together
    List<Booking> findByUser_UserIdAndStatus(@Param("userId") Integer userId, BookingStatus status);
}
