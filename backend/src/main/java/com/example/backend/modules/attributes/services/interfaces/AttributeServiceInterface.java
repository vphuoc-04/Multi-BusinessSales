package com.example.backend.modules.attributes.services.interfaces;

import java.util.Map;

import org.springframework.data.domain.Page;

import com.example.backend.modules.attributes.entities.Attribute;
import com.example.backend.modules.attributes.requests.Attribute.StoreRequest;
import com.example.backend.modules.attributes.requests.Attribute.UpdateRequest;

public interface AttributeServiceInterface {
    Attribute create(StoreRequest request, Long addedBy);
    Attribute update(Long id, UpdateRequest request, Long editedBy);
    Page<Attribute> paginate(Map<String, String[]> parameters);
    boolean delete(Long id);
}
