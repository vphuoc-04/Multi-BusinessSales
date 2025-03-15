package com.example.backend.modules.suppliers.requests.Supplier;

import java.util.List;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class StoreRequest {
    @NotBlank(message = "Name supplier is required")
    private String name;

    private List<Long> productIds;
}
