package com.example.backend.modules.products.services.interfaces;

import java.util.Map;

import org.springframework.data.domain.Page;

import com.example.backend.modules.products.entities.ProductCategory;
import com.example.backend.modules.products.requests.ProductCategory.StoreRequest;
import com.example.backend.modules.products.requests.ProductCategory.UpdateRequest;

public interface ProductCategoryServiceInterface {
    ProductCategory create(StoreRequest request, Long addedBy);
    Page<ProductCategory> paginate(Map<String, String[]> parameters);
    ProductCategory update(Long id, UpdateRequest request, Long editedBy);
    boolean delete(Long id);
}
