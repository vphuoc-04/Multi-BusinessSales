package com.example.backend.modules.attributes.services.impl;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.backend.modules.attributes.entities.Attribute;
import com.example.backend.modules.attributes.mappers.AttributeMapper;
import com.example.backend.modules.attributes.repositories.AttributeRepository;
import com.example.backend.modules.attributes.requests.Attribute.StoreRequest;
import com.example.backend.modules.attributes.requests.Attribute.UpdateRequest;
import com.example.backend.modules.attributes.services.interfaces.AttributeServiceInterface;

import com.example.backend.services.BaseService;

@Service
public class AttributeService extends BaseService<
    Attribute,
    AttributeMapper,
    StoreRequest,
    UpdateRequest,
    AttributeRepository
> implements AttributeServiceInterface {
    private static final Logger logger = LoggerFactory.getLogger(AttributeService.class);
    private final AttributeMapper attributeMapper;

    @Autowired
    private AttributeRepository attributeRepository;

    public AttributeService(
        AttributeMapper attributeMapper
    ){
        this.attributeMapper = attributeMapper;
    }

    @Override
    protected String[] getSearchFields() {
        return new String[]{"name"};
    }

    @Override
    protected AttributeRepository getRepository() {
        return attributeRepository;
    }

    @Override
    protected AttributeMapper getMapper() {
        return attributeMapper;
    }

    @Override
    protected void preSave(Attribute entity, Long addedBy, Long editedBy) {
        if (addedBy != null) {
            entity.setAddedBy(addedBy);
            logger.info("Set addedBy of attribute: {}", addedBy);
        } 
        if (editedBy != null) {
            entity.setEditedBy(editedBy);
            logger.info("Set editedBy of attribute: {}", editedBy);
        }
    }
}
