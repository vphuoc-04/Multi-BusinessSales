package com.example.backend.modules.products.services.interfaces;

import java.util.Map;

import org.springframework.data.domain.Page;
import org.springframework.web.multipart.MultipartFile;

import com.example.backend.modules.products.entities.Product;
import com.example.backend.modules.products.requests.Product.StoreRequest;
import com.example.backend.modules.products.requests.Product.UpdateRequest;

public interface ProductServiceInterface {
    Product add(StoreRequest request, MultipartFile[] images, Long addedBy);
    Product edit(Long id, UpdateRequest request, MultipartFile[] images, Long editedBy);
    Page<Product> paginate(Map<String, String[]> parameters);
    boolean delete (Long id);
}
