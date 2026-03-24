package com.smarttravel.controller;

import com.smarttravel.model.TouristSpot;
import com.smarttravel.repository.TouristSpotRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/spots")
public class TouristSpotController {

    @Autowired
    private TouristSpotRepository spotRepository;

    // GET /api/spots
    @GetMapping
    public List<TouristSpot> getAllSpots() {
        return spotRepository.findAll();
    }

    // GET /api/spots?city=Goa
    @GetMapping("/search")
    public List<TouristSpot> getSpotsByCity(@RequestParam String city) {
        return spotRepository.findByDestination_City(city);
    }

    // GET /api/spots/category?category=Beach
    @GetMapping("/category")
    public List<TouristSpot> getSpotsByCategory(@RequestParam String category) {
        return spotRepository.findByCategory(category);
    }
}
