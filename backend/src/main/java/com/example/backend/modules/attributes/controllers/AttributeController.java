package com.example.backend.modules.attributes.controllers;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.backend.controllers.BaseController;
import com.example.backend.enums.PermissionEnum;
import com.example.backend.modules.attributes.entities.Attribute;
import com.example.backend.modules.attributes.mappers.AttributeMapper;
import com.example.backend.modules.attributes.repositories.AttributeRepository;
import com.example.backend.modules.attributes.requests.Attribute.StoreRequest;
import com.example.backend.modules.attributes.requests.Attribute.UpdateRequest;
import com.example.backend.modules.attributes.resources.AttributeResource;
import com.example.backend.modules.attributes.services.interfaces.AttributeServiceInterface;

@RestController
@RequestMapping("api/v1/attribute")
public class AttributeController extends BaseController<
    Attribute,
    AttributeResource,
    StoreRequest,
    UpdateRequest,
    AttributeRepository
> {
    public AttributeController(
        AttributeServiceInterface attributeService,
        AttributeMapper attributeMapper,
        AttributeRepository attributeRepository
    ){
        super(attributeService, attributeMapper, attributeRepository, PermissionEnum.ATTRIBUTE);
    }

    @Override
    protected String getStoreSuccessMessage() {
        return "Attribute added successfully";
    }

    @Override
    protected String getUpdateSuccessMessage() {
        return "Attribute edited successfully";
    }

    @Override
    protected String getFetchSuccessMessage() {
        return "Attribute fetch success";
    }

    @Override
    protected String getDeleteSuccessMessage() {
        return "Attribute deleted successfully";
    }

    @Override
    protected String getEntityName() {
        return "Attribute";
    }
}
