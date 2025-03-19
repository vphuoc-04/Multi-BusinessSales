package com.example.backend.modules.products.services.impl;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.backend.modules.products.entities.Product;
import com.example.backend.modules.products.entities.ProductImage;
import com.example.backend.modules.products.repositories.ProductImageRepository;
import com.example.backend.modules.products.repositories.ProductRepository;
import com.example.backend.modules.products.requests.ProductImage.StoreRequest;
import com.example.backend.modules.products.requests.ProductImage.UpdateRequest;
import com.example.backend.modules.products.services.interfaces.ProductImageServiceInterface;
import com.example.backend.services.BaseService;

import jakarta.persistence.EntityNotFoundException;

@Service
public class ProductImageService extends BaseService implements ProductImageServiceInterface {
    @Autowired
    private ProductImageRepository productImageRepository;

    @Autowired
    private ProductRepository productRepository;

    private static final Logger logger = LoggerFactory.getLogger(ProductImageService.class);

    @Override
    @Transactional
    public ProductImage create(StoreRequest request, Long addedBy) {
        Product product = productRepository.findById(Long.valueOf(request.getProductId()))
            .orElseThrow(() -> new EntityNotFoundException("Product not found with ID: " + request.getProductId()));


        ProductImage payload = ProductImage.builder()
            .imageUrl(request.getImageUrl())
            .product(product)
            .addedBy(addedBy)
            .build();

        logger.info("Product image" + payload);

        return productImageRepository.save(payload);
    }

    @Override
    @Transactional
    public ProductImage update(Long id, UpdateRequest request, Long editedBy) {
        ProductImage productImage = productImageRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Image not found"));

        ProductImage payload = productImage.toBuilder()
            .imageUrl(request.getUrl())
            .editedBy(editedBy)
            .build();

        return productImageRepository.save(payload);
    }

    @Override
    public Page<ProductImage> paginate(Map<String, String[]> parameters) {
        int page = parameters.containsKey("page") ? Integer.parseInt(parameters.get("page")[0]) : 1;
        int perpage = parameters.containsKey("perpage") ? Integer.parseInt(parameters.get("perpage")[0]) : 10;
        String sortParam = parameters.containsKey("sort") ? parameters.get("sort")[0] : null;
        Sort sort = createSort(sortParam);

        Pageable pageable = PageRequest.of(page - 1, perpage, sort);

        return productImageRepository.findAll(pageable);
    }

    @Override
    @Transactional
    public boolean delete(Long id) {
        ProductImage productImage = productImageRepository.findById(id)
            .orElseThrow(() -> new EntityNotFoundException("Not found"));

        productImageRepository.delete(productImage);

        return true;
    } 
}
