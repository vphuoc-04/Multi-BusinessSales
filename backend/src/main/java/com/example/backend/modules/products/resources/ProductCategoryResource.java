package com.example.backend.modules.products.resources;

import com.fasterxml.jackson.annotation.JsonInclude;

import lombok.Builder;
import lombok.Data;
import lombok.RequiredArgsConstructor;

@Data
@Builder
@RequiredArgsConstructor
@JsonInclude(JsonInclude.Include.NON_NULL)
public class ProductCategoryResource {
    private final Long id;
    private final Long createdBy;
    private final Long updatedBy;
    private final String name;
    private final Integer publish; 
}
