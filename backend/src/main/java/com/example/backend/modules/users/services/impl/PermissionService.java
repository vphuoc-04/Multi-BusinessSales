package com.example.backend.modules.users.services.impl;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.backend.enums.PermissionEnum;
import com.example.backend.modules.users.entities.Permission;
import com.example.backend.modules.users.mappers.PermissionMapper;
import com.example.backend.modules.users.repositories.PermissionRepository;
import com.example.backend.services.BaseService;
import com.example.backend.modules.users.requests.Permission.StoreRequest;
import com.example.backend.modules.users.requests.Permission.UpdateRequest;
import com.example.backend.modules.users.services.interfaces.PermissionServiceInterface;

@Service
public class PermissionService extends BaseService<
    Permission,
    PermissionMapper,
    StoreRequest,
    UpdateRequest,
    PermissionRepository
> implements PermissionServiceInterface {
    private static final Logger logger = LoggerFactory.getLogger(PermissionService.class);
    private final PermissionMapper permissionMapper;

    @Autowired
    private PermissionRepository permissionRepository;

    public PermissionService(
        PermissionMapper permissionMapper
    ){
        this.permissionMapper = permissionMapper;
    }

    @Override
    protected String[] getSearchFields() {
        return new String[]{"name"};
    }

    @Override
    protected PermissionRepository getRepository() {
        return permissionRepository;
    }

    @Override
    protected PermissionMapper getMapper () {
        return permissionMapper;
    }

    public boolean hasPermission(String requiredPermission, PermissionEnum module, String action){
        String permission = module.getPrefix() + ":" + action;
        return requiredPermission.equals(permission);
    }

    @Override
    protected void preSave(Permission entity, Long addedBy, Long editedBy) {
        if (addedBy != null) {
            entity.setAddedBy(addedBy);
            logger.info("Set addedBy permission: {}", addedBy);
        }
        if (editedBy != null) {
            entity.setEditedBy(editedBy);
            logger.info("Set editedBy permission: {}", editedBy);
        }
    }
}
