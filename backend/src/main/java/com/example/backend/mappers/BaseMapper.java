package com.example.backend.mappers;

import java.util.List;

import org.mapstruct.BeanMapping;
import org.mapstruct.MappingTarget;
import org.springframework.data.domain.Page;

import com.example.backend.annotations.BaseMapperAnnotation;

import org.mapstruct.NullValuePropertyMappingStrategy;

public interface BaseMapper <Entity, Resource, Create, Update>{
    Resource toResource(Entity entity);

    List<Resource> toListResource(List<Entity> entities);
    
    default Page<Resource> toPageResource(Page<Entity> page) {
        return page.map(this::toResource);
    }

    @BaseMapperAnnotation
    @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    Entity toCreate(Create createRequest);

    @BaseMapperAnnotation
    @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    void toUpdate(Update updateRequest, @MappingTarget Entity entity);
}
