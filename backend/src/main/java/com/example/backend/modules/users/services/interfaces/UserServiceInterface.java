package com.example.backend.modules.users.services.interfaces;

import com.example.backend.modules.users.requests.User.StoreRequest;
import com.example.backend.modules.users.entities.User;
import com.example.backend.modules.users.requests.LoginRequest;

public interface UserServiceInterface {
    Object authenticate(LoginRequest request);
    User add(StoreRequest request, Long addedBy);
}
