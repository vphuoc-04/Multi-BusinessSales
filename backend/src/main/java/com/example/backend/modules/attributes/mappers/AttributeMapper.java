package com.example.backend.modules.attributes.mappers;

import org.mapstruct.Mapper;

import com.example.backend.mappers.BaseMapper;
import com.example.backend.modules.attributes.entities.Attribute;
import com.example.backend.modules.attributes.requests.Attribute.StoreRequest;
import com.example.backend.modules.attributes.requests.Attribute.UpdateRequest;
import com.example.backend.modules.attributes.resources.AttributeResource;

@Mapper(componentModel = "spring")
public interface AttributeMapper extends BaseMapper<Attribute, AttributeResource, StoreRequest, UpdateRequest> {
    
}
