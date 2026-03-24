package com.smarttravel.repository;

import com.smarttravel.model.Review;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import java.util.List;

public interface ReviewRepository extends JpaRepository<Review, Integer> {

    List<Review> findByHotel_HotelId(Integer hotelId);
    List<Review> findBySpot_SpotId(Integer spotId);
    List<Review> findByUser_UserId(Integer userId);

    // Average rating for a hotel
    @Query("SELECT AVG(r.rating) FROM Review r WHERE r.hotel.hotelId = :hotelId")
    Double getAvgRatingForHotel(Integer hotelId);
}
