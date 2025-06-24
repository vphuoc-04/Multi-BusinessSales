package com.example.backend.modules.orders.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

import com.example.backend.modules.orders.entities.OrderItemAttribute;

public interface OrderItemAttributeRepository extends JpaRepository<OrderItemAttribute, Long>, JpaSpecificationExecutor<OrderItemAttribute> {
    
}
