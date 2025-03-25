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

import com.example.backend.helpers.FilterParameter;
import com.example.backend.modules.products.entities.ProductCategory;
import com.example.backend.modules.products.repositories.ProductCategoryRepository;
import com.example.backend.modules.products.requests.ProductCategory.StoreRequest;
import com.example.backend.modules.products.requests.ProductCategory.UpdateRequest;
import com.example.backend.modules.products.services.interfaces.ProductCategoryServiceInterface;
import com.example.backend.services.BaseService;

import jakarta.persistence.EntityNotFoundException;

@Service
public class ProductCategoryService extends BaseService implements ProductCategoryServiceInterface {
    private static final Logger logger = LoggerFactory.getLogger(ProductCategoryService.class);

    @Autowired
    private ProductCategoryRepository productCategoryRepository;

    @Override
    @Transactional
    public ProductCategory create(StoreRequest request, Long createdBy) {
        try {
            ProductCategory payload = ProductCategory.builder()
                .name(request.getName())
                .publish(request.getPublish())
                .createdBy(createdBy)
                .build();

            return productCategoryRepository.save(payload);

        } catch (Exception e) {
            throw new RuntimeException("Transaction failed: " + e.getMessage());
        }
    }

    @Override
    public Page<ProductCategory> paginate(Map<String, String[]> parameters) {
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

        Pageable pageable = PageRequest.of(page - 1, perpage, sort);

        return productCategoryRepository.findAll(pageable);
    }

    @Override
    @Transactional
    public ProductCategory update(Long id, UpdateRequest request, Long updatedBy) {
        ProductCategory productCategory = productCategoryRepository.findById(id)
            .orElseThrow(() -> new EntityNotFoundException("Product category not found"));
        
        ProductCategory payload = productCategory.toBuilder()
            .name(request.getName())
            .publish(request.getPublish())
            .updatedBy(updatedBy)
            .build();    

        return productCategoryRepository.save(payload);
    }

    @Override
    @Transactional
    public boolean delete(Long id) {
        ProductCategory productCategory = productCategoryRepository.findById(id)
            .orElseThrow(() -> new EntityNotFoundException("Product category not found"));

        productCategoryRepository.delete(productCategory);

        return true;
    }
}
