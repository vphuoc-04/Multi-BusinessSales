package com.example.backend.modules.attributes.controllers;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.backend.controllers.BaseController;
import com.example.backend.modules.attributes.entities.AttributeValue;
import com.example.backend.modules.attributes.mappers.AttributeValueMapper;
import com.example.backend.modules.attributes.repositories.AttributeValueRepository;
import com.example.backend.modules.attributes.requests.AttributeValue.StoreRequest;
import com.example.backend.modules.attributes.requests.AttributeValue.UpdateRequest;
import com.example.backend.modules.attributes.resources.AttributeValueResource;
import com.example.backend.modules.attributes.services.interfaces.AttributeValueServiceInterface;
import com.example.backend.resources.ApiResource;

@RestController
@RequestMapping("api/v1/attribute_value")
public class AttributeValueController extends BaseController<
    AttributeValue,
    AttributeValueResource,
    StoreRequest,
    UpdateRequest,
    AttributeValueRepository
> {
    private final AttributeValueServiceInterface attributeValueService;
    private final AttributeValueMapper attributeValueMapper;

    public AttributeValueController(
        AttributeValueServiceInterface service,
        AttributeValueMapper mapper,
        AttributeValueRepository repository
    ) {
        super(service, mapper, repository);
        this.attributeValueService = service;
        this.attributeValueMapper = mapper;
    }

    @GetMapping("/by_attribute/{attributeId}")
    public ResponseEntity<?> getAttributeValuesByAttributeId(@PathVariable Long attributeId) {
        try {
            List<AttributeValue> attributeValues = attributeValueService.getAttributeValuesByAttributeId(attributeId);
            List<AttributeValueResource> attributeValueResources = attributeValueMapper.toListResource(attributeValues);
            ApiResource<List<AttributeValueResource>> response = ApiResource.ok(
                attributeValueResources,
                "List of attribute values by attributeId"
            );
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(ApiResource.error("INTERNAL_SERVER_ERROR", "Error", HttpStatus.INTERNAL_SERVER_ERROR));
        }
    }

    @Override
    protected String getStoreSuccessMessage() {
        return "Attribute value added successfully";
    }

    @Override
    protected String getUpdateSuccessMessage() {
        return "Attribute value updated successfully";
    }

    @Override
    protected String getFetchSuccessMessage() {
        return "List attribute values fetched successfully";
    }

    @Override
    protected String getDeleteSuccessMessage() {
        return "Attribute value deleted successfully";
    }

    @Override
    protected String getEntityName() {
        return "AttributeValue";
    }
}