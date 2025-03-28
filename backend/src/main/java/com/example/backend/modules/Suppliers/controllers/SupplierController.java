package com.example.backend.modules.suppliers.controllers;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
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

import com.example.backend.modules.suppliers.entities.Supplier;
import com.example.backend.modules.suppliers.mappers.SupplierMapper;
import com.example.backend.modules.suppliers.services.interfaces.SupplierServiceInterface;
import com.example.backend.resources.ApiResource;
import com.example.backend.modules.suppliers.requests.Supplier.StoreRequest;
import com.example.backend.modules.suppliers.requests.Supplier.UpdateRequest;
import com.example.backend.modules.suppliers.resources.SupplierResource;
import com.example.backend.services.JwtService;

import jakarta.persistence.EntityNotFoundException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;

@RestController
@RequestMapping("api/v1")
public class SupplierController {
    private final SupplierServiceInterface supplierService;
    private final SupplierMapper supplierMapper;

    @Autowired
    private JwtService jwtService;
    
    public SupplierController(
        SupplierServiceInterface supplierService,
        SupplierMapper supplierMapper,
        JwtService jwtService
    ){
        this.supplierService = supplierService;
        this.supplierMapper = supplierMapper;
        this.jwtService = jwtService;
    }

    @PostMapping("/supplier") 
    public ResponseEntity<?> add(@Valid @RequestBody StoreRequest request, @RequestHeader("Authorization") String bearerToken) {
        try {
            String token = bearerToken.substring(7);
            String userId = jwtService.getUserIdFromJwt(token);
            Long addedBy = Long.valueOf(userId);

            Supplier supplier = supplierService.create(request, addedBy);
            SupplierResource supplierResource = supplierMapper.toResource(supplier);
            ApiResource<SupplierResource> response = ApiResource.ok(supplierResource, "New supplier updated successfully");

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body(ApiResource.message("Network error", HttpStatus.UNAUTHORIZED));
        } 
    }

    @PutMapping("/supplier/{id}") 
    public ResponseEntity<?> add(@PathVariable Long id, @Valid @RequestBody UpdateRequest request, @RequestHeader("Authorization") String bearerToken) {
        try {
            String token = bearerToken.substring(7);
            String userId = jwtService.getUserIdFromJwt(token);
            Long addedBy = Long.valueOf(userId);

            Supplier supplier = supplierService.update(id, request, addedBy);
            SupplierResource supplierResource = supplierMapper.toResource(supplier);
            ApiResource<SupplierResource> response = ApiResource.ok(supplierResource, "New supplier added successfully");

            return ResponseEntity.ok(response);
        } catch (EntityNotFoundException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(
                ApiResource.error("NOT_FOUND", e.getMessage(), HttpStatus.NOT_FOUND)
            );
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(
                ApiResource.error("INTERNAL_SERVER_ERROR", "Error", HttpStatus.INTERNAL_SERVER_ERROR)
            );
        }   
    }

    @GetMapping("/supplier") 
    public ResponseEntity<?> index(HttpServletRequest request) {
        Map<String, String[]> parameters = request.getParameterMap();
        Page<Supplier> suppliers = supplierService.paginate(parameters);
        Page<SupplierResource> supplierResource = supplierMapper.toPageResource(suppliers);
        ApiResource<Page<SupplierResource>> response = ApiResource.ok(supplierResource, "Suppliers data fetch successfully");

        return ResponseEntity.ok(response);
    }

    @DeleteMapping("/supplier/{id}")
    public ResponseEntity<?> delete(@PathVariable Long id) {
        try {
            boolean deleted = supplierService.delete(id);

            if (deleted) {
                return ResponseEntity.ok(
                    ApiResource.message("Supplier deleted successfully", HttpStatus.OK)
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
                ApiResource.error("INTERNAL_SERVER_ERROR", "Error", HttpStatus.INTERNAL_SERVER_ERROR)
            );
        }   
    }
}
