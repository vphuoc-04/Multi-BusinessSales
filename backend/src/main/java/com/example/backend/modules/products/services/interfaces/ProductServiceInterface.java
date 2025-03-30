package com.example.backend.modules.products.services.interfaces;

import org.springframework.web.multipart.MultipartFile;

import com.example.backend.modules.products.entities.Product;
import com.example.backend.modules.products.requests.Product.StoreRequest;
import com.example.backend.modules.products.requests.Product.UpdateRequest;
import com.example.backend.services.BaseServiceInterface;

public interface ProductServiceInterface extends BaseServiceInterface<Product, StoreRequest, UpdateRequest> {
    Product add(StoreRequest request, MultipartFile[] images, Long addedBy);
    Product edit(Long id, UpdateRequest request, MultipartFile[] images, Long editedBy);
}
