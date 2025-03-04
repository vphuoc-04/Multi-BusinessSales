package com.example.backend.modules.attributes.requests.AttributeValue;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class UpdateRequest {
    @NotBlank(message = "Value is required")
    private String value;

    @NotNull(message = "Attribute ID is required")
    private Long attributeId;
}
