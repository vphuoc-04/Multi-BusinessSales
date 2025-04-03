package com.example.backend.modules.users.services.interfaces;

import com.example.backend.services.BaseServiceInterface;
import com.example.backend.modules.users.entities.Permission;
import com.example.backend.modules.users.requests.Permission.StoreRequest;
import com.example.backend.modules.users.requests.Permission.UpdateRequest;

public interface PermissionServiceInterface extends BaseServiceInterface<Permission, StoreRequest, UpdateRequest> {
    
}
