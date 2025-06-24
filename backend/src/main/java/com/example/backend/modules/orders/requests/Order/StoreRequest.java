package com.example.backend.modules.orders.requests.Order;

import java.math.BigDecimal;
import java.util.List;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class StoreRequest {
    @NotNull(message = "User ID is required")
    private Long userId;
    
    @NotNull(message = "Total amount is required")
    private BigDecimal totalAmount;
    
    private List<com.example.backend.modules.orders.requests.OrderItem.StoreRequest> items;
}