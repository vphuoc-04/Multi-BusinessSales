package com.example.backend.modules.products.requests.ProductImage;


import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class StoreRequest {
    @NotBlank(message = "Url is required")
    private String imageUrl;

    @NotNull(message = "Product id is required")
    private Long productId;
}