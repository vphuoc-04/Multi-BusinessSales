package com.example.backend.modules.users.mappers;

import org.mapstruct.BeanMapping;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.mapstruct.NullValuePropertyMappingStrategy;

import com.example.backend.annotations.BaseMapperAnnotation;
import com.example.backend.mappers.BaseMapper;
import com.example.backend.modules.users.entities.User;
import com.example.backend.modules.users.requests.User.StoreRequest;
import com.example.backend.modules.users.requests.User.UpdateRequest;
import com.example.backend.modules.users.resources.UserResource;

@Mapper(componentModel = "spring")
public interface UserMapper extends BaseMapper<User, UserResource, StoreRequest, UpdateRequest> {
    @Override
    @BaseMapperAnnotation
    @Mapping(target = "userCatalogues", ignore= true)
    @BeanMapping(nullValuePropertyMappingStrategy=NullValuePropertyMappingStrategy.IGNORE)
    User toCreate(StoreRequest createRequest);

    @Override
    @BaseMapperAnnotation
    @Mapping(target = "userCatalogues", ignore= true)
    @BeanMapping(nullValuePropertyMappingStrategy=NullValuePropertyMappingStrategy.IGNORE)
    void toUpdate(UpdateRequest UpdateRequest, @MappingTarget User entity);
}
