package com.example.backend.modules.products.controllers;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.example.backend.modules.products.entities.Product;
import com.example.backend.modules.products.mappers.ProductMapper;
import com.example.backend.modules.products.requests.Product.StoreRequest;
import com.example.backend.modules.products.requests.Product.UpdateRequest;
import com.example.backend.modules.products.resources.ProductResource;
import com.example.backend.modules.products.services.interfaces.ProductServiceInterface;
import com.example.backend.resources.ApiResource;
import com.example.backend.services.JwtService;

import jakarta.persistence.EntityNotFoundException;
import jakarta.servlet.http.HttpServletRequest;

@RestController
@RequestMapping("api/v1")
public class ProductController {
    private final ProductServiceInterface productService;
    private final ProductMapper productMapper;

    @Autowired
    private JwtService jwtService;

    public ProductController(
        ProductServiceInterface productService,
        ProductMapper productMapper,
        JwtService jwtService
    ){
        this.productService = productService;
        this.productMapper = productMapper;
        this.jwtService = jwtService;
    }

    @PostMapping("/product")
    public ResponseEntity<?> store(
            @ModelAttribute StoreRequest request, 
            @RequestParam(value = "images", required = false) MultipartFile[] images, 
            @RequestHeader("Authorization") String bearerToken) {
        try {
            String token = bearerToken.substring(7);
            String userId = jwtService.getUserIdFromJwt(token);
            Long addedBy = Long.valueOf(userId);

            Product product = productService.create(request, images, addedBy);
            ProductResource productResource = productMapper.toResource(product);

            return ResponseEntity.ok(ApiResource.ok(productResource, "Product created successfully"));
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().body(ApiResource.message(e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR));
        }
    }

    @PutMapping("/product/{id}")
    public ResponseEntity<?> update(
        @PathVariable Long id,
        @ModelAttribute UpdateRequest request,
        @RequestParam(value = "images", required = false) MultipartFile[] images,
        @RequestHeader("Authorization") String bearerToken) {
    
        try {
            String token = bearerToken.substring(7);
            String userId = jwtService.getUserIdFromJwt(token);
            Long editedBy = Long.valueOf(userId);
    
            Product product = productService.update(id, request, images, editedBy);
            ProductResource productResource = productMapper.toResource(product);
            ApiResource<ProductResource> response = ApiResource.ok(productResource, "Product updated successfully");

            return ResponseEntity.ok(response);
        } catch (EntityNotFoundException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(
                ApiResource.error("NOT_FOUND", e.getMessage(), HttpStatus.NOT_FOUND)
            );
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(
                ApiResource.message(e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR)
            );
        }
    }    

    @GetMapping("/product")
    public ResponseEntity<?> index(HttpServletRequest request) {
        Map<String, String[]> parameters = request.getParameterMap();
        Page<Product> products = productService.paginate(parameters);
        Page<ProductResource> productResource = productMapper.toPageResource(products);
        ApiResource<Page<ProductResource>> response = ApiResource.ok(productResource, "Fetch product data successfully");
        return ResponseEntity.ok(response);
    }

    @DeleteMapping("/product/{id}")
    public ResponseEntity<?> delete(@PathVariable Long id) {
        try {
            boolean deleted = productService.delete(id);

            if (deleted) {
                return ResponseEntity.ok(
                    ApiResource.message("Product deleted successfully", HttpStatus.OK)
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
