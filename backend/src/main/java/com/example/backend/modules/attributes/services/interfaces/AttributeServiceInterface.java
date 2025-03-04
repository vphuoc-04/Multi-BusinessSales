package com.example.backend.modules.attributes.services.interfaces;

import java.util.List;

import com.example.backend.modules.attributes.entities.Attribute;
import com.example.backend.modules.attributes.requests.Attribute.StoreRequest;
import com.example.backend.modules.attributes.requests.Attribute.UpdateRequest;

public interface AttributeServiceInterface {
    Attribute create(StoreRequest request, Long addedBy);
    Attribute update(Long id, UpdateRequest request, Long editedBy);
    List<Attribute> getAllAttributes();
    boolean delete(Long id);
}
