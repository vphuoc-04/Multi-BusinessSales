package com.example.backend.modules.users.services.impl;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.backend.modules.users.entities.UserCatalogue;
import com.example.backend.modules.users.mappers.UserCatalogueMapper;
import com.example.backend.modules.users.repositories.UserCatalogueRepository;
import com.example.backend.modules.users.requests.UserCatalogue.StoreRequest;
import com.example.backend.modules.users.requests.UserCatalogue.UpdateRequest;
import com.example.backend.modules.users.services.interfaces.UserCatalogueServiceInterface;
import com.example.backend.services.BaseService;

@Service
public class UserCatalogueService extends BaseService<
    UserCatalogue, 
    UserCatalogueMapper, 
    StoreRequest, 
    UpdateRequest,
    UserCatalogueRepository
> implements UserCatalogueServiceInterface {
    private static final Logger logger = LoggerFactory.getLogger(UserCatalogueService.class);
    private final UserCatalogueMapper userCatalogueMapper;

    @Autowired
    private UserCatalogueRepository userCataloguesRepository;

    public UserCatalogueService(
        UserCatalogueMapper userCatalogueMapper
    ){
        this.userCatalogueMapper = userCatalogueMapper;
    }

    @Override
    protected String[] getSearchFields() {
        return new String[]{"name"};
    }

    @Override
    protected String[] getRelations() {
        return new String[]{"permissions"};
    }

    @Override
    protected UserCatalogueRepository getRepository(){
        return userCataloguesRepository;
    }

    @Override
    protected UserCatalogueMapper getMapper(){
        return userCatalogueMapper;
    }

    @Override
    protected void preSave(UserCatalogue entity, Long addedBy, Long editedBy) {
        if (addedBy != null) {
            entity.setAddedBy(addedBy);
            logger.info("Set addedBy: {}", addedBy);
        }
        if (editedBy != null) {
            entity.setEditedBy(editedBy);
            logger.info("Set editedBy: {}", editedBy);
        }
    }
}