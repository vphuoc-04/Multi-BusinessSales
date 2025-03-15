package com.example.backend.modules.suppliers.resources;

import com.fasterxml.jackson.annotation.JsonInclude;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
@JsonInclude(JsonInclude.Include.NON_NULL)
public class SupplierResource {
    private final Long id;
    private final Long addedBy;
    private final Long editedBy;
    private final String name;
}
