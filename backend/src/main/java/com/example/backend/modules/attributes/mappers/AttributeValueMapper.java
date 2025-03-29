package com.example.backend.modules.attributes.mappers;

import java.util.List;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Named;

import com.example.backend.mappers.BaseMapper;
import com.example.backend.modules.attributes.entities.AttributeValue;
import com.example.backend.modules.attributes.requests.AttributeValue.StoreRequest;
import com.example.backend.modules.attributes.requests.AttributeValue.UpdateRequest;
import com.example.backend.modules.attributes.resources.AttributeValueResource;

@Mapper(componentModel = "spring")
public interface AttributeValueMapper extends BaseMapper<AttributeValue, AttributeValueResource, StoreRequest, UpdateRequest> {
    @Named("toAttributeValueResource")
    @Mapping(target = "attribute", source = "attribute")
    AttributeValueResource toResource(AttributeValue attributeValue);

    @Named("toAttributeValueResource")
    default List<AttributeValueResource> toResource(List<AttributeValue> attributeValues) {
        if (attributeValues == null) {
            return List.of();
        }
        return attributeValues.stream()
            .map(this::toResource)
            .toList();
    }

    @Override
    @Mapping(target = "attribute", ignore = true) 
    AttributeValue toCreate(StoreRequest createRequest);
}