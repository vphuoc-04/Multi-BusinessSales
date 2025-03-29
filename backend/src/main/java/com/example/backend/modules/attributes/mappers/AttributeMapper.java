package com.example.backend.modules.attributes.mappers;

import com.example.backend.mappers.BaseMapper;
import com.example.backend.modules.attributes.entities.Attribute;
import com.example.backend.modules.attributes.requests.Attribute.StoreRequest;
import com.example.backend.modules.attributes.requests.Attribute.UpdateRequest;
import com.example.backend.modules.attributes.resources.AttributeResource;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.ReportingPolicy;
import org.springframework.data.domain.Page;

@Mapper(
    unmappedTargetPolicy = ReportingPolicy.IGNORE,
    componentModel = "spring",
    uses = {AttributeValueMapper.class}
)
public interface AttributeMapper extends BaseMapper<Attribute, AttributeResource, StoreRequest, UpdateRequest> {
    @Override
    @Mapping(target = "id", source = "id")
    @Mapping(target = "name", source = "name")
    @Mapping(target = "addedBy", source = "addedBy")
    @Mapping(target = "editedBy", source = "editedBy")
    @Mapping(target = "attributeValue", source = "attributeValues", qualifiedByName = "toAttributeValueResource")
    AttributeResource toResource(Attribute attribute);

    
    @Override
    default Page<AttributeResource> toPageResource(Page<Attribute> attributes) {
        if (attributes == null) {
            return null;
        }
        return attributes.map(this::toResource);
    }
}