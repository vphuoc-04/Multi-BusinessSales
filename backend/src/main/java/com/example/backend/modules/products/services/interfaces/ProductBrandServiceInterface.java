package com.example.backend.modules.products.services.interfaces;

import java.util.Map;

import org.springframework.data.domain.Page;

import com.example.backend.modules.products.entities.ProductBrand;
import com.example.backend.modules.products.requests.ProductBrand.StoreRequest;
import com.example.backend.modules.products.requests.ProductBrand.UpdateRequest;

public interface ProductBrandServiceInterface {
    ProductBrand add(StoreRequest request, Long addedBy);
    ProductBrand edit(Long id, UpdateRequest request, Long editedBy);
    Page<ProductBrand> paginate(Map<String, String[]> parameters);
    boolean delete(Long id);
}
