package com.example.backend.modules.suppliers.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.backend.modules.suppliers.entities.Supplier;

@Repository
public interface SupplierRepository extends JpaRepository<Supplier, Long> {
    
}
