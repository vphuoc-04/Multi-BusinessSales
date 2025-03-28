package com.example.backend.modules.users.mappers;

import org.mapstruct.Mapper;

import com.example.backend.mappers.BaseMapper;
import com.example.backend.modules.users.entities.UserCatalogue;
import com.example.backend.modules.users.requests.UserCatalogue.StoreRequest;
import com.example.backend.modules.users.requests.UserCatalogue.UpdateRequest;
import com.example.backend.modules.users.resources.UserCatalogueResource;

@Mapper(componentModel = "spring")
public interface UserCatalogueMapper extends BaseMapper<UserCatalogue, UserCatalogueResource, StoreRequest, UpdateRequest> {

}
