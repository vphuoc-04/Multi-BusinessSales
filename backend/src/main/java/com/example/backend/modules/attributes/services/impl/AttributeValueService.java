package com.example.backend.modules.attributes.services.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.backend.modules.attributes.entities.Attribute;
import com.example.backend.modules.attributes.entities.AttributeValue;
import com.example.backend.modules.attributes.repositories.AttributeRepository;
import com.example.backend.modules.attributes.repositories.AttributeValueRepository;
import com.example.backend.modules.attributes.requests.AttributeValue.StoreRequest;
import com.example.backend.modules.attributes.requests.AttributeValue.UpdateRequest;
import com.example.backend.modules.attributes.services.interfaces.AttributeValueServiceInterface;
import com.example.backend.services.BaseService;

import jakarta.persistence.EntityNotFoundException;

@Service
public class AttributeValueService extends BaseService implements AttributeValueServiceInterface {
    @Autowired
    private AttributeValueRepository attributeValueRepository;

    @Autowired
    private AttributeRepository attributeRepository;

    @Override
    @Transactional
    public AttributeValue create(StoreRequest request, Long addedBy) {
        try {
            Attribute attribute = attributeRepository.findById(request.getAttributeId())
                .orElseThrow(() -> new EntityNotFoundException("Attribute not found"));

            AttributeValue payload = AttributeValue.builder()
                .value(request.getValue())
                .attribute(attribute)
                .addedBy(addedBy)
                .build();
            
            return attributeValueRepository.save(payload);

        } catch (Exception e) {
            throw new RuntimeException("Transactional failed: " + e.getMessage());
        }
    }

    @Override
    @Transactional
    public AttributeValue update(Long id, UpdateRequest request, Long editedBy) {
        AttributeValue attributeValue = attributeValueRepository.findById(id)
            .orElseThrow(() -> new EntityNotFoundException("Attribute value not found"));

        AttributeValue payload = attributeValue.toBuilder()
            .value(request.getValue())
            .editedBy(editedBy)
            .build();

        return attributeValueRepository.save(payload);
    }

    @Override
    public List<AttributeValue> getAttributeValuesByAttributeId(Long attributeId) {
        return attributeValueRepository.findByAttributeId(attributeId);
    }

    @Override
    @Transactional
    public boolean delete(Long id) {
        AttributeValue attributeValue = attributeValueRepository.findById(id)
            .orElseThrow(() -> new EntityNotFoundException("Attribute not found"));

            attributeValueRepository.delete(attributeValue);

        return true;
    }
}
