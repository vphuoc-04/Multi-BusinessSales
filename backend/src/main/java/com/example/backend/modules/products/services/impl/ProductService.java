package com.example.backend.modules.products.services.impl;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.example.backend.helpers.FilterParameter;
import com.example.backend.modules.products.entities.Product;
import com.example.backend.modules.products.entities.ProductBrand;
import com.example.backend.modules.products.entities.ProductImage;
import com.example.backend.modules.products.repositories.ProductRepository;
import com.example.backend.modules.products.repositories.ProductBrandRepository;
import com.example.backend.modules.products.repositories.ProductImageRepository;
import com.example.backend.modules.products.requests.Product.StoreRequest;
import com.example.backend.modules.products.requests.Product.UpdateRequest;
import com.example.backend.modules.products.services.interfaces.ProductServiceInterface;
import com.example.backend.services.BaseService;
import com.example.backend.specifications.BaseSpecification;

import jakarta.persistence.EntityNotFoundException;

@Service
public class ProductService extends BaseService implements ProductServiceInterface {
    private static final Logger logger = LoggerFactory.getLogger(ProductService.class);

    @Autowired
    private ProductRepository productRepository;
    
    @Autowired
    private ProductImageRepository productImageRepository;

    @Autowired
    private ProductBrandRepository productBrandRepository;

    @Override
    @Transactional
    public Product create(StoreRequest request, MultipartFile[] images, Long addedBy) {
        try {
            ProductBrand brand = null;
            if (request.getBrandId() != null) {
                brand = productBrandRepository.findById(request.getBrandId())
                    .orElseThrow(() -> new RuntimeException("Brand not found"));
            }

            Product payload = Product.builder()
                .productCategoryId(request.getProductCategoryId())
                .productCode(request.getProductCode())
                .name(request.getName())
                .price(request.getPrice())
                .addedBy(addedBy)
                .brand(brand)
                .build();

            Product product = productRepository.save(payload);

            if (images != null && images.length > 0) {
                List<ProductImage> imageList = new ArrayList<>();
                String uploadDir = "../frontend/assets/uploads/";

                for (MultipartFile image : images) {
                    String filename = UUID.randomUUID().toString() + "_" + image.getOriginalFilename();
                    Path filePath = Paths.get(uploadDir + filename);

                    Files.copy(image.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);

                    ProductImage productImage = ProductImage.builder()
                            .imageUrl("/assets/uploads/" + filename)
                            .product(product)
                            .addedBy(addedBy)
                            .build();
                    imageList.add(productImage);
                }

                productImageRepository.saveAll(imageList);
            }

            return product;
        } catch (Exception e) {
            throw new RuntimeException("Transaction failed: " + e.getMessage());
        }
    }

    @Override
    @Transactional
    public Product update(Long id, UpdateRequest request, MultipartFile[] images, Long editedBy) {
        try {
            Product product = productRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Product not found"));
    
            ProductBrand brand = null;
            if (request.getBrandId() != null) {
                brand = productBrandRepository.findById(request.getBrandId())
                    .orElseThrow(() -> new RuntimeException("Brand not found"));
            }
    
            product.setProductCategoryId(request.getProductCategoryId());
            product.setProductCode(request.getProductCode());
            product.setName(request.getName());
            product.setPrice(request.getPrice());
            product.setBrand(brand);
            product.setEditedBy(editedBy);
    
            Product updatedProduct = productRepository.save(product);
    
            if (images != null && images.length > 0) {
                productImageRepository.deleteByProductId(product.getId());
    
                List<ProductImage> imageList = new ArrayList<>();
                String uploadDir = "../frontend/assets/uploads/";
    
                for (MultipartFile image : images) {
                    String filename = UUID.randomUUID().toString() + "_" + image.getOriginalFilename();
                    Path filePath = Paths.get(uploadDir + filename);
    
                    Files.copy(image.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);
    
                    ProductImage productImage = ProductImage.builder()
                            .imageUrl("/assets/uploads/" + filename)
                            .product(updatedProduct)
                            .addedBy(editedBy)
                            .build();
                    imageList.add(productImage);
                }
    
                productImageRepository.saveAll(imageList);
            }
    
            return updatedProduct;
        } catch (Exception e) {
            throw new RuntimeException("Update transaction failed: " + e.getMessage());
        }
    }

    @Override
    public Page<Product> paginate(Map<String, String[]> parameters) {
        int page = parameters.containsKey("page") ? Integer.parseInt(parameters.get("page")[0]) : 1;
        int perpage = parameters.containsKey("perpage") ? Integer.parseInt(parameters.get("perpage")[0]) : 10;
        String sortParam = parameters.containsKey("sort") ? parameters.get("sort")[0] : null;
        Sort sort = createSort(sortParam);

        String keyword = FilterParameter.filterKeyword(parameters);

        Map<String, String> filterSimple = FilterParameter.filterSimple(parameters);

        Map<String, Map<String, String>> filterComplex = FilterParameter.filterComplex(parameters);

        logger.info("Keyword: " + keyword);
        logger.info("Filter simple: {}", filterSimple );
        logger.info("Filter complex: {}", filterComplex);

        Specification<Product> specs = Specification.where(
            BaseSpecification.<Product>keywordSpec(keyword, "name")
        )
        .and(BaseSpecification.<Product>whereSpec(filterSimple))
        .and(BaseSpecification.<Product>complexWhereSpec(filterComplex));

        Pageable pageable = PageRequest.of(page - 1, perpage, sort);

        return productRepository.findAll(specs, pageable);
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
