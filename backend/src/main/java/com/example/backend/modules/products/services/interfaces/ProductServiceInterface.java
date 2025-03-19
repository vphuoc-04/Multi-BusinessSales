package com.example.backend.modules.products.services.interfaces;

import java.util.Map;

import org.springframework.data.domain.Page;

import com.example.backend.modules.products.entities.Product;
import com.example.backend.modules.products.requests.Product.StoreRequest;
import com.example.backend.modules.products.requests.Product.UpdateRequest;

public interface ProductServiceInterface {
    Product create(StoreRequest request, Long addedBy);
    Product update(Long id, UpdateRequest request, Long editedBy);
    Page<Product> paginate(Map<String, String[]> parameters);
    boolean delete (Long id);
}
