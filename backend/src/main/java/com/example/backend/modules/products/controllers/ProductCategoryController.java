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

import com.example.backend.modules.products.entities.ProductCategory;
import com.example.backend.modules.products.mappers.ProductCategoryMapper;
import com.example.backend.modules.products.requests.ProductCategory.StoreRequest;
import com.example.backend.modules.products.requests.ProductCategory.UpdateRequest;
import com.example.backend.modules.products.resources.ProductCategoryResource;
import com.example.backend.modules.products.services.interfaces.ProductCategoryServiceInterface;
import com.example.backend.resources.ApiResource;
import com.example.backend.services.JwtService;

import jakarta.persistence.EntityNotFoundException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;

@RestController
@RequestMapping("api/v1")
public class ProductCategoryController {
    private final ProductCategoryServiceInterface productCategoryService;
    private final ProductCategoryMapper productCategoryMapper;

    @Autowired
    private JwtService jwtService;

    public ProductCategoryController(
        ProductCategoryServiceInterface productCategoryService,
        ProductCategoryMapper productCategoryMapper,
        JwtService jwtService
    ){
        this.productCategoryService = productCategoryService;
        this.productCategoryMapper = productCategoryMapper;
        this.jwtService = jwtService;
    }

    @PostMapping("/product_category")
    public ResponseEntity<?> store(@Valid @RequestBody StoreRequest request, @RequestHeader("Authorization") String bearerToken) {
        try {
            String token = bearerToken.substring(7);
            String userId = jwtService.getUserIdFromJwt(token);
            Long createdBy = Long.valueOf(userId);

            ProductCategory productCategory = productCategoryService.add(request, createdBy);
            ProductCategoryResource productCategoryResource = productCategoryMapper.toResource(productCategory);
            ApiResource<ProductCategoryResource> response = ApiResource.ok(productCategoryResource, "Product catagory added successfulyy");

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body(ApiResource.message("Network error", HttpStatus.UNAUTHORIZED));
        }
    }

    @GetMapping("/product_category")
    public ResponseEntity<?> index(HttpServletRequest request) {
        Map<String, String[]> parameters = request.getParameterMap();
        Page<ProductCategory> productCategories = productCategoryService.paginate(parameters);
        Page<ProductCategoryResource> productCategoryResource = productCategoryMapper.toPageResource(productCategories);
        ApiResource<Page<ProductCategoryResource>> response = ApiResource.ok(productCategoryResource, "Product category data fetched successfully");

        return ResponseEntity.ok(response);
    }

    @PutMapping("/product_category/{id}")
    public ResponseEntity<?> update(@PathVariable Long id, @Valid @RequestBody UpdateRequest request, @RequestHeader("Authorization") String bearerToken) {
        try {
            String token = bearerToken.substring(7);
            String userId = jwtService.getUserIdFromJwt(token);
            Long updatedBy = Long.valueOf(userId);

            ProductCategory productCategory = productCategoryService.edit(id, request, updatedBy);
            ProductCategoryResource productCategoryResource = productCategoryMapper.toResource(productCategory);
            ApiResource<ProductCategoryResource> response = ApiResource.ok(productCategoryResource, "Product category updated successfully");

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

    @DeleteMapping("/product_category/{id}")
    public ResponseEntity<?> delete(@PathVariable Long id) {
        try {
            boolean deleted = productCategoryService.delete(id);

            if (deleted) {
                return ResponseEntity.ok(
                    ApiResource.message("Product category deleted successfully", HttpStatus.OK)
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
