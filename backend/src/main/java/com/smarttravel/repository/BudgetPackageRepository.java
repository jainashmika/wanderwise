package com.smarttravel.repository;

import com.smarttravel.model.BudgetPackage;
import org.springframework.data.jpa.repository.JpaRepository;
import java.math.BigDecimal;
import java.util.List;

public interface BudgetPackageRepository extends JpaRepository<BudgetPackage, Integer> {

    List<BudgetPackage> findByDestination_City(String city);
    List<BudgetPackage> findByTotalCostLessThanEqual(BigDecimal maxCost);
    List<BudgetPackage> findByDurationDays(Integer days);
}
