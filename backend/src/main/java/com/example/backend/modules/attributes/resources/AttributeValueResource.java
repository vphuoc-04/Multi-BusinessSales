package com.example.backend.modules.attributes.resources;

import com.fasterxml.jackson.annotation.JsonInclude;

import lombok.Builder;
import lombok.Data;
import lombok.RequiredArgsConstructor;

@Data
@Builder
@RequiredArgsConstructor
@JsonInclude(JsonInclude.Include.NON_NULL)
public class AttributeValueResource {
    private final Long id;
    private final String value;
    private final Long addedBy;
    private final Long editedBy;
    private final AttributeResource attribute;
}
