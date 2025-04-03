package com.example.backend.modules.users.services.interfaces;

import com.example.backend.modules.users.requests.User.StoreRequest;
import com.example.backend.modules.users.requests.User.UpdateRequest;
import com.example.backend.services.BaseServiceInterface;

import com.example.backend.modules.users.entities.User;
import com.example.backend.modules.users.requests.LoginRequest;

public interface UserServiceInterface extends BaseServiceInterface<User, StoreRequest, UpdateRequest> {
    Object authenticate(LoginRequest request);
}
