package com.example.backend.modules.orders.resources;

import java.math.BigDecimal;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonInclude;

import lombok.Builder;
import lombok.Data;
import lombok.RequiredArgsConstructor;

@Data
@Builder
@RequiredArgsConstructor
@JsonInclude(JsonInclude.Include.NON_NULL)
public class OrderItemResource {
    private final Long id;
    private final Long orderId;
    private final Long productId;
    private final Integer quantity;
    private final BigDecimal unitPrice;
    private final List<OrderItemAttributeResource> attributes;
}