package com.smarttravel.controller;

import com.smarttravel.model.Hotel;
import com.smarttravel.repository.HotelRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.util.List;

@RestController
@RequestMapping("/api/hotels")
public class HotelController {

    @Autowired
    private HotelRepository hotelRepository;

    // GET /api/hotels — returns ALL hotels
    @GetMapping
    public List<Hotel> getAllHotels() {
        return hotelRepository.findAll();
    }

    // GET /api/hotels/{id} — returns one hotel by ID
    @GetMapping("/{id}")
    public ResponseEntity<Hotel> getHotelById(@PathVariable Integer id) {
        return hotelRepository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // GET /api/hotels/search?city=Goa&maxPrice=5000
    @GetMapping("/search")
    public List<Hotel> searchHotels(
            @RequestParam(required = false) String city,
            @RequestParam(required = false) BigDecimal maxPrice) {

        if (city != null && maxPrice != null) {
            return hotelRepository.searchHotels(city, maxPrice);
        } else if (city != null) {
            return hotelRepository.findByDestination_City(city);
        } else if (maxPrice != null) {
            return hotelRepository.findByPricePerNightLessThanEqual(maxPrice);
        }
        return hotelRepository.findAll();
    }

    // POST /api/hotels — add a new hotel (admin use)
    @PostMapping
    public Hotel addHotel(@RequestBody Hotel hotel) {
        return hotelRepository.save(hotel);
    }
}
