package com.example.backend.modules.products.resources;

import com.fasterxml.jackson.annotation.JsonInclude;

import lombok.Builder;
import lombok.Data;
import lombok.RequiredArgsConstructor;

@Data
@Builder
@RequiredArgsConstructor
@JsonInclude(JsonInclude.Include.NON_NULL)
public class ProductImageResource {
    private final Long id;
    private final String url;
    private final Long addedBy;
    private final Long editedBy;
    private final Long productId;
}
