package com.example.backend.mappers;

import org.mapstruct.BeanMapping;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.springframework.data.domain.Page;
import org.mapstruct.NullValuePropertyMappingStrategy;

public interface BaseMapper <Entity, Resource, Create, Update>{
    Resource toResource(Entity entity);

    default Page<Resource> toPageResource(Page<Entity> page) {
        return page.map(this::toResource);
    }

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdAt", ignore = true)
    @Mapping(target = "updatedAt", ignore = true)
    @Mapping(target = "addedBy", ignore = true)
    @Mapping(target = "editedBy", ignore = true)
    @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    Entity toCreate(Create createRequest);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "createdAt", ignore= true)
    @Mapping(target = "updatedAt", ignore= true)
    @Mapping(target = "addedBy", ignore = true)
    @Mapping(target = "editedBy", ignore = true)
    @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    void toUpdate(Update updateRequest, @MappingTarget Entity entity);
}
