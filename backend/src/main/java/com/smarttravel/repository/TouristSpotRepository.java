package com.smarttravel.repository;

import com.smarttravel.model.TouristSpot;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface TouristSpotRepository extends JpaRepository<TouristSpot, Integer> {

    List<TouristSpot> findByDestination_City(String city);
    List<TouristSpot> findByCategory(String category);
}
