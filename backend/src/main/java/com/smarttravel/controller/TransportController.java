package com.smarttravel.controller;

import com.smarttravel.model.Transport;
import com.smarttravel.repository.TransportRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/transport")
public class TransportController {

    @Autowired
    private TransportRepository transportRepository;

    // GET /api/transport
    @GetMapping
    public List<Transport> getAllTransport() {
        return transportRepository.findAll();
    }

    // GET /api/transport/search?source=Delhi&destination=Goa
    @GetMapping("/search")
    public List<Transport> searchTransport(
            @RequestParam String source,
            @RequestParam String destination) {
        return transportRepository
                .findBySourceContainingIgnoreCaseAndDestinationContainingIgnoreCase(source, destination);
    }
}
