package com.example.backend.modules.products.controllers;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.example.backend.controllers.BaseController;
import com.example.backend.enums.PermissionEnum;
import com.example.backend.modules.products.entities.Product;
import com.example.backend.modules.products.mappers.ProductMapper;
import com.example.backend.modules.products.repositories.ProductRepository;
import com.example.backend.modules.products.requests.Product.StoreRequest;
import com.example.backend.modules.products.requests.Product.UpdateRequest;
import com.example.backend.modules.products.resources.ProductResource;
import com.example.backend.modules.products.services.interfaces.ProductServiceInterface;

import jakarta.validation.Valid;

@RestController
@RequestMapping("api/v1/product")
public class ProductController extends BaseController<
    Product,
    ProductResource,
    StoreRequest,
    UpdateRequest,
    ProductRepository
> {
    private final ProductServiceInterface productService;

    public ProductController(
        ProductServiceInterface service,
        ProductMapper mapper,
        ProductRepository repository
    ){
        super(service, mapper, repository, PermissionEnum.PRODUCT);
        this.productService = service;
    }

    @Override
    protected Product addWithFiles(StoreRequest request, MultipartFile[] files, Long userId) {
        return productService.add(request, files, userId);
    }

    @Override
    protected Product editWithFiles(Long id, UpdateRequest request, MultipartFile[] files, Long userId) {
        return productService.edit(id, request, files, userId);
    }

    @PostMapping(consumes = "multipart/form-data")
    public ResponseEntity<?> storeWithFiles(
        @Valid StoreRequest request,
        @RequestParam(value = "images", required = false) MultipartFile[] images,
        @RequestHeader("Authorization") String bearerToken
    ){
        return super.storeWithFiles(request, images, bearerToken);
    }

    @PutMapping(value = "/{id}", consumes = "multipart/form-data")
    public ResponseEntity<?> updateWithFiles(
        @PathVariable Long id,
        @Valid UpdateRequest request,
        @RequestParam(value = "images", required = false) MultipartFile[] images,
        @RequestHeader("Authorization") String bearerToken
    ){
        return super.updateWithFiles(id, request, images, bearerToken);
    }

    @Override
    protected String getStoreSuccessMessage() {
        return "Product created successfully";
    }

    @Override
    protected String getUpdateSuccessMessage() {
        return "Product updated successfully";
    }

    @Override
    protected String getFetchSuccessMessage() {
        return "Fetch product data successfully";
    }

    @Override
    protected String getDeleteSuccessMessage() {
        return "Product deleted successfully";
    }

    @Override
    protected String getEntityName() {
        return "Product";
    }
}