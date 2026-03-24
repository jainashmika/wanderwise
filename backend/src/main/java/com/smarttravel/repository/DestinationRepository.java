package com.smarttravel.repository;

import com.smarttravel.model.Destination;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface DestinationRepository extends JpaRepository<Destination, Integer> {

    Optional<Destination> findByCity(String city);
}
