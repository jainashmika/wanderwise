package com.smarttravel.controller;

import com.smarttravel.model.Destination;
import com.smarttravel.repository.DestinationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/destinations")
public class DestinationController {

    @Autowired
    private DestinationRepository destinationRepository;

    // GET /api/destinations — list all destinations for homepage/dropdown
    @GetMapping
    public List<Destination> getAllDestinations() {
        return destinationRepository.findAll();
    }
}
