package com.example.backend.modules.users.mappers;

import com.example.backend.modules.users.entities.Permission;

import org.mapstruct.BeanMapping;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.NullValuePropertyMappingStrategy;

import com.example.backend.annotations.BaseMapperAnnotation;
import com.example.backend.mappers.BaseMapper;

import com.example.backend.modules.users.resources.PermissionResource;
import com.example.backend.modules.users.requests.Permission.StoreRequest;
import com.example.backend.modules.users.requests.Permission.UpdateRequest;

@Mapper(componentModel = "spring")
public interface PermissionMapper extends BaseMapper<Permission, PermissionResource, StoreRequest, UpdateRequest> {
    @Override
    @BaseMapperAnnotation
    @Mapping(target = "userCatalogues", ignore= true)
    @BeanMapping(nullValuePropertyMappingStrategy=NullValuePropertyMappingStrategy.IGNORE)
    Permission toCreate(StoreRequest createRequest);


    @Override
    @Mapping(target = "userCatalogues", ignore = true) 
    @BaseMapperAnnotation
    void toUpdate(UpdateRequest updateRequest, @MappingTarget Permission entity);
}
