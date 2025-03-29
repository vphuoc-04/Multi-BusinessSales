package com.example.backend.modules.attributes.services.interfaces;

import java.util.List;

import com.example.backend.modules.attributes.entities.AttributeValue;
import com.example.backend.modules.attributes.requests.AttributeValue.StoreRequest;
import com.example.backend.modules.attributes.requests.AttributeValue.UpdateRequest;

public interface AttributeValueServiceInterface {
    AttributeValue add(StoreRequest request, Long addedBy);
    AttributeValue edit(Long id, UpdateRequest request, Long editedBy);
    List<AttributeValue> getAttributeValuesByAttributeId(Long attributeId);
    boolean delete(Long id);
}
