package com.example.backend.modules.products.requests.ProductImage;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class UpdateRequest {
    @NotBlank(message = "Url is requried")
    private String url;
}
