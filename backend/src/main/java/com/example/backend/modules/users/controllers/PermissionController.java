package com.example.backend.modules.users.controllers;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.backend.controllers.BaseController;
import com.example.backend.enums.PermissionEnum;
import com.example.backend.modules.users.entities.Permission;
import com.example.backend.modules.users.mappers.PermissionMapper;
import com.example.backend.modules.users.repositories.PermissionRepository;
import com.example.backend.modules.users.resources.PermissionResource;
import com.example.backend.modules.users.services.interfaces.PermissionServiceInterface;
import com.example.backend.modules.users.requests.Permission.StoreRequest;
import com.example.backend.modules.users.requests.Permission.UpdateRequest;

@RestController
@RequestMapping("api/v1/permissions")
public class PermissionController extends BaseController<
    Permission,
    PermissionResource,
    StoreRequest,
    UpdateRequest,
    PermissionRepository
> {
    public PermissionController(
        PermissionServiceInterface permissionService,
        PermissionMapper permissionMapper,
        PermissionRepository permissionRepository
    ){
        super(permissionService, permissionMapper, permissionRepository, PermissionEnum.PERMISSION);
    }

    @Override
    protected String getStoreSuccessMessage() {
        return "Permission added successfully";
    }

    @Override
    protected String getUpdateSuccessMessage() {
        return "Permission edited successfully";
    }

    @Override
    protected String getFetchSuccessMessage() {
        return "Permission fetch success";
    }

    @Override
    protected String getDeleteSuccessMessage() {
        return "Permission deleted successfully";
    }

    @Override
    protected String getEntityName() {
        return "Permission";
    }
}
