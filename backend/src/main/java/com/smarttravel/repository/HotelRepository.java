package com.smarttravel.repository;

import com.smarttravel.model.Hotel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.math.BigDecimal;
import java.util.List;

public interface HotelRepository extends JpaRepository<Hotel, Integer> {

    // Find hotels in a specific city (joins via Destination)
    List<Hotel> findByDestination_City(String city);

    // Find hotels under a certain price
    List<Hotel> findByPricePerNightLessThanEqual(BigDecimal maxPrice);

    // Find hotels by minimum rating
    List<Hotel> findByRatingGreaterThanEqual(BigDecimal minRating);

    // Custom JPQL query: search hotels by city AND max price
    @Query("SELECT h FROM Hotel h WHERE h.destination.city = :city AND h.pricePerNight <= :maxPrice")
    List<Hotel> searchHotels(@Param("city") String city, @Param("maxPrice") BigDecimal maxPrice);

    // Find hotels that still have rooms available
    List<Hotel> findByAvailableRoomsGreaterThan(Integer rooms);
}
