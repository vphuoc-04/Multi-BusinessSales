package com.example.backend.modules.attributes.requests.Attribute;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class UpdateRequest {
    @NotBlank(message = "Name is required")
    private String name;
}
