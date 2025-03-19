package com.example.backend.modules.products.controllers;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.example.backend.modules.products.entities.ProductImage;
import com.example.backend.modules.products.requests.ProductImage.StoreRequest;
import com.example.backend.modules.products.requests.ProductImage.UpdateRequest;
import com.example.backend.modules.products.resources.ProductImageResource;
import com.example.backend.modules.products.services.interfaces.ProductImageServiceInterface;
import com.example.backend.resources.ApiResource;
import com.example.backend.services.JwtService;

import jakarta.persistence.EntityNotFoundException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;

@RestController
@RequestMapping("api/v1")
public class ProductImageController {
    private final ProductImageServiceInterface productImageService;
    private static final Logger logger = LoggerFactory.getLogger(ProductImageController.class);

    @Autowired
    private JwtService jwtService;

    public ProductImageController(
        ProductImageServiceInterface productImageService,
        JwtService jwtService
    ) {
        this.productImageService = productImageService;
        this.jwtService = jwtService;
    }

    @PostMapping("/product_image")
    public ResponseEntity<?> store(@Valid @RequestBody StoreRequest request, @RequestHeader("Authorization") String bearerToken) {
        try {
            String token = bearerToken.substring(7);
            logger.info("Token: " + token);

            String userId = jwtService.getUserIdFromJwt(token);
            logger.info("UserId: " + userId);

            Long addedBy = Long.valueOf(userId);
            logger.info("Added by: " + addedBy);


            ProductImage productImage = productImageService.create(request, addedBy);

            ProductImageResource productImageResource = ProductImageResource.builder()
                .id(productImage.getId())
                .addedBy(productImage.getAddedBy())
                .editedBy(productImage.getEditedBy())
                .url(productImage.getImageUrl())
                .productId(productImage.getProduct() != null ? productImage.getProduct().getId() : null)
                .build();

            ApiResource<ProductImageResource> response = ApiResource.ok(productImageResource, "Image added successfully");

            return ResponseEntity.ok(response);

        } catch (Exception e) {
            return ResponseEntity.internalServerError().body(ApiResource.message("NETWORK_ERROR", HttpStatus.UNAUTHORIZED));
        }
    }

    @PutMapping("/product_image/{id}") 
    public ResponseEntity<?> update(@PathVariable Long id, @Valid @RequestBody UpdateRequest request, @RequestHeader("Authorization") String bearerToken) {
        try {
            String token = bearerToken.substring(7);

            String userId = jwtService.getUserIdFromJwt(token);
            
            Long updatedBy = Long.valueOf(userId);

            ProductImage productImage = productImageService.update(id, request, updatedBy);

            ProductImageResource productImageResource = ProductImageResource.builder()
                .id(productImage.getId())
                .addedBy(productImage.getAddedBy())
                .editedBy(productImage.getEditedBy())
                .url(productImage.getImageUrl())
                .productId(productImage.getProduct().getId())
                .build();

            ApiResource<ProductImageResource> response = ApiResource.ok(productImageResource, "Image updated successfully");

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

    @GetMapping("/product_image")
    public ResponseEntity<?> index(HttpServletRequest request) {
        Map<String, String[]> parameters = request.getParameterMap();

        Page<ProductImage> productImages = productImageService.paginate(parameters);

        Page<ProductImageResource> productImageResource = productImages.map(productImage -> 
            ProductImageResource.builder()
                .id(productImage.getId())
                .addedBy(productImage.getAddedBy())
                .editedBy(productImage.getEditedBy())
                .url(productImage.getImageUrl())
                .productId(productImage.getProduct().getId())
                .build()
        );

        ApiResource<Page<ProductImageResource>> response = ApiResource.ok(productImageResource, "Fetch list images");

        return ResponseEntity.ok(response);
    }

    @DeleteMapping("/product_image/{id}")
    public ResponseEntity<?> delete(@PathVariable Long id) {
        try {
            boolean deleted = productImageService.delete(id);

            if (deleted) {
                return ResponseEntity.ok(
                    ApiResource.message("Image deleted successfully", HttpStatus.OK)
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
