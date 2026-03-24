package com.smarttravel.repository;

import com.smarttravel.model.Transport;
import com.smarttravel.model.Transport.TransportType;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface TransportRepository extends JpaRepository<Transport, Integer> {

    // Find transport by source and destination city (exact)
    List<Transport> findBySourceAndDestination(String source, String destination);

    // Find transport by partial/case-insensitive source and destination
    List<Transport> findBySourceContainingIgnoreCaseAndDestinationContainingIgnoreCase(String source, String destination);

    // Find transport by type (Bus/Train/Flight)
    List<Transport> findByType(TransportType type);

    // Find available transport (has seats)
    List<Transport> findByAvailableSeatsGreaterThan(Integer seats);
}
