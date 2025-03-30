package com.example.backend.modules.attributes.services.interfaces;

import com.example.backend.modules.attributes.entities.Attribute;
import com.example.backend.modules.attributes.requests.Attribute.StoreRequest;
import com.example.backend.modules.attributes.requests.Attribute.UpdateRequest;
import com.example.backend.services.BaseServiceInterface;

public interface AttributeServiceInterface extends BaseServiceInterface<Attribute, StoreRequest, UpdateRequest> {

}
