package com.example.backend.modules.products.resources;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonInclude;

import lombok.Builder;
import lombok.Data;
import lombok.RequiredArgsConstructor;

@Data
@Builder
@RequiredArgsConstructor
@JsonInclude(JsonInclude.Include.NON_NULL)
public class ProductResource {
    private final Long id;
    private final Long addedBy;
    private final Long editedBy;
    private final Long productCategoryId;
    private final String productCode;
    private final String name;
    private final Double price;
    private final Long brandId; 
    private final List<String> imageUrls; 
}
