package com.example.backend.modules.attributes.mappers;

import org.mapstruct.Mapper;

import com.example.backend.mappers.BaseMapper;
import com.example.backend.modules.attributes.entities.AttributeValue;
import com.example.backend.modules.attributes.requests.AttributeValue.StoreRequest;
import com.example.backend.modules.attributes.requests.AttributeValue.UpdateRequest;
import com.example.backend.modules.attributes.resources.AttributeValueResource;

@Mapper(componentModel = "spring")
public interface AttributeValueMapper extends BaseMapper<AttributeValue, AttributeValueResource, StoreRequest, UpdateRequest> {
    
}
