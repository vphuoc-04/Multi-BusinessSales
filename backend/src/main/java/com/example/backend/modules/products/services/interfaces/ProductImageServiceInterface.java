package com.example.backend.modules.products.services.interfaces;

import java.util.Map;

import org.springframework.data.domain.Page;

import com.example.backend.modules.products.entities.ProductImage;
import com.example.backend.modules.products.requests.ProductImage.StoreRequest;
import com.example.backend.modules.products.requests.ProductImage.UpdateRequest;

public interface ProductImageServiceInterface {
    ProductImage create(StoreRequest request, Long addedBy);
    ProductImage update(Long id, UpdateRequest request, Long editedBy);
    Page<ProductImage> paginate(Map<String, String[]> parameters);
    boolean delete(Long id);
}
