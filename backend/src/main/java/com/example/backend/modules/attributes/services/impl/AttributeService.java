package com.example.backend.modules.attributes.services.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.backend.modules.attributes.entities.Attribute;
import com.example.backend.modules.attributes.repositories.AttributeRepository;
import com.example.backend.modules.attributes.requests.Attribute.StoreRequest;
import com.example.backend.modules.attributes.requests.Attribute.UpdateRequest;
import com.example.backend.modules.attributes.services.interfaces.AttributeServiceInterface;
import com.example.backend.services.BaseService;

import jakarta.persistence.EntityNotFoundException;

@Service
public class AttributeService extends BaseService implements AttributeServiceInterface {
    @Autowired
    private AttributeRepository attributeRepository;

    @Override
    @Transactional
    public Attribute create(StoreRequest request, Long addedBy) {
        try {
            Attribute payload = Attribute.builder()
                .name(request.getName())
                .addedBy(addedBy)
                .build();
            
            return attributeRepository.save(payload);

        } catch (Exception e) {
            throw new RuntimeException("Transactional failed: " + e.getMessage());
        }
    }

    @Override
    @Transactional
    public Attribute update(Long id, UpdateRequest request, Long editedBy) {
        Attribute attribute = attributeRepository.findById(id)
            .orElseThrow(() -> new EntityNotFoundException("Attribute not found"));

        Attribute payload = attribute.toBuilder()
            .name(request.getName())
            .editedBy(editedBy)
            .build();

        return attributeRepository.save(payload);
    }

    @Override
    public List<Attribute> getAllAttributes() {
        return attributeRepository.findAll();
    }

    @Override
    @Transactional
    public boolean delete(Long id) {
        Attribute attribute = attributeRepository.findById(id)
            .orElseThrow(() -> new EntityNotFoundException("Attribute not found"));

        attributeRepository.delete(attribute);

        return true;
    }
}
