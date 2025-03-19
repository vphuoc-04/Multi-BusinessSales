package com.example.backend.modules.products.services.impl;

import java.util.List;
import java.util.Map;

import java.util.stream.Collectors;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;


import com.example.backend.modules.products.entities.Product;
import com.example.backend.modules.products.entities.ProductImage;
import com.example.backend.modules.products.repositories.ProductRepository;
import com.example.backend.modules.products.repositories.ProductImageRepository;
import com.example.backend.modules.products.requests.Product.StoreRequest;
import com.example.backend.modules.products.requests.Product.UpdateRequest;
import com.example.backend.modules.products.services.interfaces.ProductServiceInterface;
import com.example.backend.services.BaseService;

import jakarta.persistence.EntityNotFoundException;

@Service
public class ProductService extends BaseService implements ProductServiceInterface {
    private static final Logger logger = LoggerFactory.getLogger(ProductService.class);

    @Autowired
    private ProductRepository productRepository;
    
    @Autowired
    private ProductImageRepository productImageRepository;

    @Override
    @Transactional
    public Product create(StoreRequest request, Long addedBy) {
        try {
            Product payload = Product.builder()
                .productCategoryId(request.getProductCategoryId())
                .productCode(request.getProductCode())
                .name(request.getName())
                .price(request.getPrice())
                .addedBy(addedBy)
                .build();
            
            Product product = productRepository.save(payload);

            if (request.getImageUrls() != null && !request.getImageUrls().isEmpty()) {
                List<ProductImage> images = request.getImageUrls().stream()
                    .map(url -> ProductImage.builder()
                        .imageUrl(url)
                        .product(product)
                        .addedBy(addedBy)
                        .build())
                    .collect(Collectors.toList());
                
                productImageRepository.saveAll(images);
            }
        
            return product;

        } catch (Exception e) {
            throw new RuntimeException("Transaction failed: " + e.getMessage());
        }
    }

    @Override
    @Transactional
    public Product update(Long id, UpdateRequest request, Long editedBy) {
        logger.info("Product id: " + id);
        Product product = productRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Product not found"));


        Product payload = product.toBuilder()
            .id(product.getId()) 
            .productCategoryId(request.getProductCategoryId() != null ? request.getProductCategoryId() : product.getProductCategoryId())
            .productCode(request.getProductCode() != null ? request.getProductCode() : product.getProductCode())
            .name(request.getName() != null ? request.getName() : product.getName())
            .price(request.getPrice() != null ? request.getPrice() : product.getPrice())
            .editedBy(editedBy)
            .build();

        Product saveProduct = productRepository.save(payload);
            if (request.getImageUrls() != null) {
                productImageRepository.deleteByProductId(product.getId()); 

                if (!request.getImageUrls().isEmpty()) { 
                    List<ProductImage> images = request.getImageUrls().stream()
                        .map(url -> ProductImage.builder()
                            .imageUrl(url)
                            .product(saveProduct)
                            .addedBy(editedBy)
                            .build())
                        .collect(Collectors.toList());

                    try {
                        productImageRepository.saveAll(images);
                    } catch (Exception e) {
                        System.out.println("Lỗi khi lưu ảnh: " + e.getMessage());
                    }
                }
            }
        
        return saveProduct;
    }


    @Override
    public Page<Product> paginate(Map<String, String[]> parameters) {
        int page = parameters.containsKey("page") ? Integer.parseInt(parameters.get("page")[0]) : 1;
        int perpage = parameters.containsKey("perpage") ? Integer.parseInt(parameters.get("perpage")[0]) : 10;
        String sortParam = parameters.containsKey("sort") ? parameters.get("sort")[0] : null;
        Sort sort = createSort(sortParam);

        Pageable pageable = PageRequest.of(page - 1, perpage, sort);

        return productRepository.findAll(pageable);
    }

    @Override
    @Transactional
    public boolean delete(Long id) {
        Product product = productRepository.findById(id)
            .orElseThrow(() -> new EntityNotFoundException("Not found"));

        productRepository.delete(product);
        
        return true;
    } 
}
