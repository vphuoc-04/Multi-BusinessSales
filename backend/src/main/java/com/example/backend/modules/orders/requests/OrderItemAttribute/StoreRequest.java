package com.example.backend.modules.orders.requests.OrderItemAttribute;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class StoreRequest {
    @NotNull(message = "Order item ID is required")
    private Long orderItemId;

    @NotNull(message = "Attribute value ID is required")
    private Long attributeValueId;
}