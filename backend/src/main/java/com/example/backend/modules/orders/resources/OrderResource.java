package com.example.backend.modules.orders.resources;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.Builder;
import lombok.Data;
import lombok.RequiredArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Data
@Builder
@RequiredArgsConstructor
@JsonInclude(JsonInclude.Include.NON_NULL)
public class OrderResource {
    private final Long id;
    private final Long userId;
    private final Long addedBy;
    private final Long editedBy;
    private final LocalDateTime orderDate;
    private final String status;
    private final BigDecimal totalAmount;
    private final List<OrderItemResource> items;
}