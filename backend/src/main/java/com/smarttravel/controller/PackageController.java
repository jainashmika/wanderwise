package com.smarttravel.controller;

import com.smarttravel.model.BudgetPackage;
import com.smarttravel.repository.BudgetPackageRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.math.BigDecimal;
import java.util.List;

@RestController
@RequestMapping("/api/packages")
public class PackageController {

    @Autowired
    private BudgetPackageRepository packageRepository;

    // GET /api/packages or /api/packages?city=Goa
    @GetMapping
    public List<BudgetPackage> getAllPackages(@RequestParam(required = false) String city) {
        if (city != null && !city.trim().isEmpty()) {
            return packageRepository.findByDestination_City(city);
        }
        return packageRepository.findAll();
    }

    // GET /api/packages/{id}
    @GetMapping("/{id}")
    public ResponseEntity<BudgetPackage> getById(@PathVariable Integer id) {
        return packageRepository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    // GET /api/packages/destination/{id}
    @GetMapping("/destination/{id}")
    public List<BudgetPackage> getByDestinationId(@PathVariable Integer id) {
        return packageRepository.findByDestination_DestinationId(id);
    }

    // GET /api/packages/search?city=Goa&maxCost=20000
    @GetMapping("/search")
    public List<BudgetPackage> search(
            @RequestParam(required = false) String city,
            @RequestParam(required = false) BigDecimal maxCost) {

        if (city != null) return packageRepository.findByDestination_City(city);
        if (maxCost != null) return packageRepository.findByTotalCostLessThanEqual(maxCost);
        return packageRepository.findAll();
    }
}

