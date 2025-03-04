package com.example.backend.modules.attributes.controllers;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.backend.modules.attributes.entities.AttributeValue;
import com.example.backend.modules.attributes.repositories.AttributeRepository;
import com.example.backend.modules.attributes.requests.AttributeValue.UpdateRequest;
import com.example.backend.modules.attributes.requests.AttributeValue.StoreRequest;
import com.example.backend.modules.attributes.resources.AttributeResource;
import com.example.backend.modules.attributes.resources.AttributeValueResource;
import com.example.backend.modules.attributes.services.interfaces.AttributeValueServiceInterface;
import com.example.backend.resources.ApiResource;
import com.example.backend.services.JwtService;

import jakarta.persistence.EntityNotFoundException;
import jakarta.validation.Valid;

@RestController
@RequestMapping("api/v1")
public class AttributeValueController {
    private final AttributeValueServiceInterface attributeValueService;

    @Autowired
    private JwtService jwtService;

    public AttributeValueController(
        AttributeValueServiceInterface attributeValueService,
        JwtService jwtService,
        AttributeRepository attributeRepository
    ){
        this.attributeValueService = attributeValueService;
        this.jwtService = jwtService;
    }

    @PostMapping("/attribute_value")
    public ResponseEntity<?> store(@Valid @RequestBody StoreRequest request, @RequestHeader("Authorization") String bearerToken) {
        try {
            String token = bearerToken.substring(7);

            String userId = jwtService.getUserIdFromJwt(token);

            Long addedBy = Long.valueOf(userId);

            AttributeValue attributeValue = attributeValueService.create(request, addedBy);

            AttributeValueResource attributeValueResource = AttributeValueResource.builder()
                .id(attributeValue.getId())
                .value(attributeValue.getValue())
                .addedBy(addedBy)
                .build();

            ApiResource<AttributeValueResource> response = ApiResource.ok(attributeValueResource, "Attribute value added successfully");

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            return ResponseEntity.internalServerError().body(ApiResource.message("NETWORK_ERROR", HttpStatus.UNAUTHORIZED));
        }
    }

    @PutMapping("/attribute_value/{id}")
    public ResponseEntity<?> update(@PathVariable Long id, @Valid @RequestBody UpdateRequest request, @RequestHeader("Authorization") String bearerToken) {
        try {
            String token = bearerToken.substring(7);
            
            String userId = jwtService.getUserIdFromJwt(token);

            Long editedBy = Long.valueOf(userId);

            AttributeValue attributeValue = attributeValueService.update(id, request, editedBy);

            AttributeValueResource attributeValueResource = AttributeValueResource.builder()
                .id(attributeValue.getId())
                .value(attributeValue.getValue())
                .editedBy(editedBy)
                .build();

            ApiResource<AttributeValueResource> response = ApiResource.ok(attributeValueResource, "Attribute value updated successfully");

            return ResponseEntity.ok(response);

        } catch (EntityNotFoundException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(
                ApiResource.error("NOT_FOUND", e.getMessage(), HttpStatus.NOT_FOUND)
            );
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(
                ApiResource.error("INTERNAL_SERVER_ERROR", "ERROR", HttpStatus.INTERNAL_SERVER_ERROR)
            );
        }
    }

    @GetMapping("/attribute_value")
    public ResponseEntity<?> getAllAttributeValues() {
        try {
            List<AttributeValue> attributeValues = attributeValueService.getAllAttributeValues();

            List<AttributeValueResource> attributeValueResources = attributeValues.stream()
                .map(attributeValue -> {
                    AttributeResource attributeResource = null;
                    if (attributeValue.getAttribute() != null) {
                        attributeResource = AttributeResource.builder()
                            .id(attributeValue.getAttribute().getId())
                            .name(attributeValue.getAttribute().getName())
                            .build();
                    }
                    
                    return AttributeValueResource.builder()
                        .id(attributeValue.getId())
                        .value(attributeValue.getValue())
                        .addedBy(attributeValue.getAddedBy())
                        .attribute(attributeResource) 
                        .build();
                })
                .toList();

            ApiResource<List<AttributeValueResource>> response = ApiResource.ok(attributeValueResources, "List of attributes");

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body(ApiResource.message("NETWORK_ERROR", HttpStatus.UNAUTHORIZED));
        }
    }

    @DeleteMapping("/attribute_value/{id}")
    public ResponseEntity<?> delete(@PathVariable Long id) {
        try {
            boolean deleted = attributeValueService.delete(id);

            if (deleted) {
                return ResponseEntity.ok(
                    ApiResource.message("Attribute value deleted successfully", HttpStatus.OK)
                );
            } else {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(
                    ApiResource.error("NOT_FOUND", "Error", HttpStatus.NOT_FOUND)
                );
            }

        } catch (EntityNotFoundException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(
                ApiResource.error("NOT_FOUND", e.getMessage(), HttpStatus.NOT_FOUND)
            );
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(
                ApiResource.error("INTERNAL_SERVER_ERROR", e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR)
            );
        }   
    }
}
