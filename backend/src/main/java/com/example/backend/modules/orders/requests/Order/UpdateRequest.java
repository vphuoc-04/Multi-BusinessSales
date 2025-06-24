package com.example.backend.modules.orders.requests.Order;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class UpdateRequest {
    @NotNull(message = "Status is required")
    private String status;
}