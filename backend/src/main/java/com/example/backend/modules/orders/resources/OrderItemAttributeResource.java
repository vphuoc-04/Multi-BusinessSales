package com.example.backend.modules.orders.resources;

import com.fasterxml.jackson.annotation.JsonInclude;

import lombok.Builder;
import lombok.Data;
import lombok.RequiredArgsConstructor;

@Data
@Builder
@RequiredArgsConstructor
@JsonInclude(JsonInclude.Include.NON_NULL)
public class OrderItemAttributeResource {
    private final Long id;
    private final Long attributeValueId;
}