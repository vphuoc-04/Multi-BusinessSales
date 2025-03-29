package com.example.backend.modules.products.controllers;

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

import com.example.backend.modules.products.entities.ProductBrand;
import com.example.backend.modules.products.mappers.ProductBrandMapper;
import com.example.backend.modules.products.requests.ProductBrand.StoreRequest;
import com.example.backend.modules.products.requests.ProductBrand.UpdateRequest;
import com.example.backend.modules.products.resources.ProductBrandResource;
import com.example.backend.modules.products.services.interfaces.ProductBrandServiceInterface;
import com.example.backend.resources.ApiResource;
import com.example.backend.services.JwtService;

import jakarta.persistence.EntityNotFoundException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;

@RestController
@RequestMapping("api/v1")
public class ProductBrandController {
    private final ProductBrandServiceInterface productBrandService;
    private final ProductBrandMapper productBrandMapper;

    @Autowired
    private JwtService jwtService;

    public ProductBrandController(
        ProductBrandServiceInterface productBrandService,
        ProductBrandMapper productBrandMapper,
        JwtService jwtService
    ){
        this.productBrandService = productBrandService;
        this.productBrandMapper = productBrandMapper;
        this.jwtService = jwtService;
    }

    @PostMapping("/product_brand")
    public ResponseEntity<?> store(@Valid @RequestBody StoreRequest request, @RequestHeader("Authorization") String bearerToken) {
        try {
            String token = bearerToken.substring(7);
            String userId = jwtService.getUserIdFromJwt(token);
            Long addedBy = Long.valueOf(userId);

            ProductBrand productBrand = productBrandService.add(request, addedBy);
            ProductBrandResource productBrandResource = productBrandMapper.toResource(productBrand);
            ApiResource<ProductBrandResource> response = ApiResource.ok(productBrandResource, "Brand added successfully");

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body(ApiResource.message("NETWORK_ERROR", HttpStatus.UNAUTHORIZED));
        }
    }

    @PutMapping("/product_brand/{id}") 
    public ResponseEntity<?> update(@PathVariable Long id, @Valid @RequestBody UpdateRequest request, @RequestHeader("Authorization") String bearerToken) {
        try {
            String token = bearerToken.substring(7);
            String userId = jwtService.getUserIdFromJwt(token);
            Long updatedBy = Long.valueOf(userId);

            ProductBrand productBrand = productBrandService.edit(id, request, updatedBy);
            ProductBrandResource productBrandResource = productBrandMapper.toResource(productBrand);
            ApiResource<ProductBrandResource> response = ApiResource.ok(productBrandResource, "Brand updated successfully");

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

    @GetMapping("/product_brand")
    public ResponseEntity<?> index(HttpServletRequest request) {
        Map<String, String[]> parameters = request.getParameterMap();
        Page<ProductBrand> productBrands = productBrandService.paginate(parameters);
        Page<ProductBrandResource> productBrandResource = productBrandMapper.toPageResource(productBrands);
        ApiResource<Page<ProductBrandResource>> response = ApiResource.ok(productBrandResource, "Fetch list brand");

        return ResponseEntity.ok(response);
    }

    @DeleteMapping("/product_brand/{id}")
    public ResponseEntity<?> delete(@PathVariable Long id) {
        try {
            boolean deleted = productBrandService.delete(id);

            if (deleted) {
                return ResponseEntity.ok(
                    ApiResource.message("Brand deleted successfully", HttpStatus.OK)
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
