package com.example.backend.modules.users.controllers;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.backend.controllers.BaseController;
import com.example.backend.modules.users.entities.UserCatalogue;
import com.example.backend.modules.users.mappers.UserCatalogueMapper;
import com.example.backend.modules.users.repositories.UserCatalogueRepository;
import com.example.backend.modules.users.requests.UserCatalogue.StoreRequest;
import com.example.backend.modules.users.requests.UserCatalogue.UpdateRequest;
import com.example.backend.modules.users.resources.UserCatalogueResource;
import com.example.backend.modules.users.services.interfaces.UserCatalogueServiceInterface;

@RestController
@RequestMapping("api/v1")
public class UserCatalogueController extends BaseController<
    UserCatalogue,
    UserCatalogueResource,
    StoreRequest,
    UpdateRequest,
    UserCatalogueRepository
> {

    public UserCatalogueController(
        UserCatalogueServiceInterface userCatagoluesService,
        UserCatalogueMapper userCatalogueMapper,
        UserCatalogueRepository userCatalogueRepository
    ){
        super(userCatagoluesService, userCatalogueMapper, userCatalogueRepository);
    }

    @Override
    protected String getStoreSuccessMessage() {
        return "User catalogue added successfully";
    }

    @Override
    protected String getUpdateSuccessMessage() {
        return "User catalogue edited successfully";
    }

    @Override
    protected String getFetchSuccessMessage() {
        return "User catalogue fetch success";
    }

    @Override
    protected String getDeleteSuccessMessage() {
        return "User catalogue deleted successfully";
    }

    @Override
    protected String getEntityName() {
        return "User catalogue";
    }
}
