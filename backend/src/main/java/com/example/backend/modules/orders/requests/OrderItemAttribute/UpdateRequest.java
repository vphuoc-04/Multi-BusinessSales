package com.example.backend.modules.orders.requests.OrderItemAttribute;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class UpdateRequest {
    @NotNull(message = "Attribute value ID is required")
    private Long attributeValueId;
}