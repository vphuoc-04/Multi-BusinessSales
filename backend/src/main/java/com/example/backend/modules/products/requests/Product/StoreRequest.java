package com.example.backend.modules.products.requests.Product;

import java.util.List;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class StoreRequest {
    @NotBlank(message = "Product code is required")
    private String productCode;

    @NotNull(message = "Product category id is required")
    private Long productCategoryId;

    @NotBlank(message = "Name is required")
    private String name;

    @NotNull(message = "Price is required")
    private Double price;

    private List<String> imageUrls;
}
