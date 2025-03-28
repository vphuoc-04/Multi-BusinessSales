package com.example.backend.modules.users.mappers;

import org.mapstruct.Mapper;

import com.example.backend.mappers.BaseMapper;
import com.example.backend.modules.users.entities.User;
import com.example.backend.modules.users.requests.User.StoreRequest;
import com.example.backend.modules.users.requests.User.UpdateRequest;
import com.example.backend.modules.users.resources.UserResource;

@Mapper(componentModel = "spring")
public interface UserMapper extends BaseMapper<User, UserResource, StoreRequest, UpdateRequest> {
    
}
