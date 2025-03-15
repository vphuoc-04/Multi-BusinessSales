package com.example.backend.modules.suppliers.requests.Supplier;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class UpdateRequest {
    @NotBlank(message = "Name supplier is required")
    private String name;
}
