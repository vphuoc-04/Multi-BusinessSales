package com.example.backend.modules.users.mappers;

import org.mapstruct.BeanMapping;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.NullValuePropertyMappingStrategy;

import com.example.backend.annotations.BaseMapperAnnotation;
import com.example.backend.mappers.BaseMapper;
import com.example.backend.modules.users.entities.UserCatalogue;
import com.example.backend.modules.users.requests.UserCatalogue.StoreRequest;
import com.example.backend.modules.users.requests.UserCatalogue.UpdateRequest;
import com.example.backend.modules.users.resources.UserCatalogueResource;

@Mapper(componentModel = "spring")
public interface UserCatalogueMapper extends BaseMapper<UserCatalogue, UserCatalogueResource, StoreRequest, UpdateRequest> {
    @Override
    @BaseMapperAnnotation
    @Mapping(target = "permissions", ignore = true)
    @Mapping(target = "users", ignore = true)
    @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    UserCatalogue toCreate(StoreRequest request);

    @Override
    @BaseMapperAnnotation
    @Mapping(target = "permissions", ignore = true)
    @Mapping(target = "users", ignore = true)
    @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    void toUpdate(UpdateRequest request, @MappingTarget UserCatalogue entity);
}
