package com.example.backend.modules.attributes.services.impl;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.backend.modules.attributes.entities.Attribute;
import com.example.backend.modules.attributes.entities.AttributeValue;
import com.example.backend.modules.attributes.mappers.AttributeValueMapper;
import com.example.backend.modules.attributes.repositories.AttributeRepository;
import com.example.backend.modules.attributes.repositories.AttributeValueRepository;
import com.example.backend.modules.attributes.requests.AttributeValue.StoreRequest;
import com.example.backend.modules.attributes.requests.AttributeValue.UpdateRequest;
import com.example.backend.modules.attributes.services.interfaces.AttributeValueServiceInterface;
import com.example.backend.services.BaseService;

import jakarta.persistence.EntityNotFoundException;

@Service
public class AttributeValueService extends BaseService<
    AttributeValue,
    AttributeValueMapper,
    StoreRequest,
    UpdateRequest,
    AttributeValueRepository
> implements AttributeValueServiceInterface {
    private static final Logger logger = LoggerFactory.getLogger(AttributeValueService.class);
    private final AttributeValueMapper attributeValueMapper;
    private final AttributeRepository attributeRepository; 

    @Autowired
    private AttributeValueRepository attributeValueRepository;

    public AttributeValueService(
        AttributeValueMapper attributeValueMapper,
        AttributeRepository attributeRepository 
    ){
        this.attributeValueMapper = attributeValueMapper;
        this.attributeRepository = attributeRepository;
    }

    @Override
    protected String[] getSearchFields() {
        return new String[]{"value"};
    }

    @Override
    protected AttributeValueRepository getRepository() {
        return attributeValueRepository;
    }

    @Override 
    protected AttributeValueMapper getMapper() {
        return attributeValueMapper;
    }

    @Override
    public List<AttributeValue> getAttributeValuesByAttributeId(Long attributeId) {
        return attributeValueRepository.findByAttributeId(attributeId);
    }

    @Override
    protected Long getRelationIdFromCreate(StoreRequest request) {
        return request.getAttributeId(); 
    }

    @Override
    protected Long getRelationIdFromUpdate(UpdateRequest request) {
        return request.getAttributeId(); 
    }

    @Override
    protected void setRelation(AttributeValue entity, Long relationId) {
        Attribute attribute = attributeRepository.findById(relationId)
            .orElseThrow(() -> new IllegalArgumentException("Attribute with ID " + relationId + " not found"));
        entity.setAttribute(attribute); 
    }

    @Override
    public AttributeValue add(StoreRequest request, Long userId) {
        Attribute attribute = attributeRepository.findById(request.getAttributeId())
            .orElseThrow(() -> new EntityNotFoundException("Attribute id not found: " + request.getAttributeId()));

        AttributeValue attributeValue = attributeValueMapper.toCreate(request);
            attributeValue.setAttribute(attribute);
            attributeValue.setAddedBy(userId);     
        logger.info("Set addedBy of attribute value: {}", userId);

        return attributeValueRepository.save(attributeValue);
    }

    @Override
    protected void preSave(AttributeValue entity, Long addedBy, Long editedBy) {
        if (addedBy != null) {
            entity.setAddedBy(addedBy);
            logger.info("Set addedBy of attribute value: {}", addedBy);
        }
        if (editedBy != null) {
            entity.setEditedBy(editedBy);
            logger.info("Set editedBy of attribute value: {}", editedBy);
        }
    }
}