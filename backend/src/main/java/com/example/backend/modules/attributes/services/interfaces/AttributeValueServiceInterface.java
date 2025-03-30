package com.example.backend.modules.attributes.services.interfaces;

import java.util.List;

import com.example.backend.modules.attributes.entities.AttributeValue;
import com.example.backend.modules.attributes.requests.AttributeValue.StoreRequest;
import com.example.backend.modules.attributes.requests.AttributeValue.UpdateRequest;
import com.example.backend.services.BaseServiceInterface;

public interface AttributeValueServiceInterface extends BaseServiceInterface <AttributeValue, StoreRequest, UpdateRequest> {
    List<AttributeValue> getAttributeValuesByAttributeId(Long attributeId);
}
