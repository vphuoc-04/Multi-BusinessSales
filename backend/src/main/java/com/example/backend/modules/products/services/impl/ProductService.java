package com.example.backend.modules.products.services.impl;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.example.backend.modules.products.entities.Product;
import com.example.backend.modules.products.entities.ProductBrand;
import com.example.backend.modules.products.entities.ProductImage;
import com.example.backend.modules.products.mappers.ProductMapper;
import com.example.backend.modules.products.repositories.ProductBrandRepository;
import com.example.backend.modules.products.repositories.ProductRepository;
import com.example.backend.modules.products.requests.Product.StoreRequest;
import com.example.backend.modules.products.requests.Product.UpdateRequest;
import com.example.backend.modules.products.services.interfaces.ProductServiceInterface;
import com.example.backend.services.BaseService;

@Service
public class ProductService extends BaseService<
    Product,
    ProductMapper,
    StoreRequest,
    UpdateRequest,
    ProductRepository
> implements ProductServiceInterface {
    private static final Logger logger = LoggerFactory.getLogger(ProductService.class);

    private final ProductMapper productMapper;
    private final String uploadDir = "../frontend/assets/uploads/";

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private ProductBrandRepository productBrandRepository;

    public ProductService(ProductMapper productMapper) {
        this.productMapper = productMapper;
    }

    @Override
    protected String[] getSearchFields() {
        return new String[]{"name"};
    }

    @Override
    protected ProductRepository getRepository() {
        return productRepository;
    }

    @Override
    protected ProductMapper getMapper() {
        return productMapper;
    }

    @Override
    protected void preSave(Product entity, Long addedBy, Long editedBy) {
        if (addedBy != null) {
            entity.setAddedBy(addedBy);
            logger.info("Set addedBy: {}", addedBy);
        }
        if (editedBy != null) {
            entity.setEditedBy(editedBy);
            logger.info("Set editedBy: {}", editedBy);
        }
    }

    @Override
    @Transactional
    public Product add(StoreRequest request, MultipartFile[] images, Long addedBy) {
        Product product = super.add(request, addedBy); 
        return updateProductWithBrandAndImages(product, request.getBrandId(), images, addedBy);
    }

    @Override
    @Transactional
    public Product edit(Long id, UpdateRequest request, MultipartFile[] images, Long editedBy) {
        Product product = super.edit(id, request, editedBy); 
        return updateProductWithBrandAndImages(product, request.getBrandId(), images, editedBy);
    }

    private Product updateProductWithBrandAndImages(Product product, Long brandId, MultipartFile[] images, Long userId) {
        try {
            if (brandId != null) {
                ProductBrand brand = productBrandRepository.findById(brandId)
                    .orElseThrow(() -> new RuntimeException("Brand not found"));
                product.setBrand(brand);
            }

            if (images != null && images.length > 0) {
                List<ProductImage> imageList = product.getImages() != null ? product.getImages() : new ArrayList<>();
                imageList.clear(); 

                for (MultipartFile image : images) {
                    String filename = UUID.randomUUID() + "_" + image.getOriginalFilename();
                    Path filePath = Paths.get(uploadDir + filename);
                    Files.copy(image.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);

                    ProductImage productImage = ProductImage.builder()
                        .imageUrl("/assets/uploads/" + filename)
                        .product(product)
                        .addedBy(userId)
                        .build();
                    imageList.add(productImage);
                }

                product.setImages(imageList);
                productRepository.save(product); 
            }

            return product;
        } catch (Exception e) {
            throw new RuntimeException("Failed to update product with brand/images: " + e.getMessage());
        }
    }
}