package com.example.backend.modules.products.services.impl;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.example.backend.modules.products.entities.ProductCategory;
import com.example.backend.modules.products.mappers.ProductCategoryMapper;
import com.example.backend.modules.products.repositories.ProductCategoryRepository;
import com.example.backend.modules.products.requests.ProductCategory.StoreRequest;
import com.example.backend.modules.products.requests.ProductCategory.UpdateRequest;
import com.example.backend.modules.products.services.interfaces.ProductCategoryServiceInterface;
import com.example.backend.services.BaseService;

@Service
public class ProductCategoryService extends BaseService<
    ProductCategory,
    ProductCategoryMapper,
    StoreRequest,
    UpdateRequest,
    ProductCategoryRepository
>implements ProductCategoryServiceInterface {
    private static final Logger logger = LoggerFactory.getLogger(ProductCategoryService.class);
    private final ProductCategoryMapper productCategoryMapper;

    @Autowired
    private ProductCategoryRepository productCategoryRepository;

    public ProductCategoryService(
        ProductCategoryMapper productCategoryMapper
    ){
        this.productCategoryMapper = productCategoryMapper;
    }

    @Override
    protected String[] getSearchFields() {
        return new String[]{"name"};
    }

    @Override
    protected ProductCategoryRepository getRepository() {
        return productCategoryRepository;
    }

    @Override 
    protected ProductCategoryMapper getMapper() {
        return productCategoryMapper;
    }

    @Override
    protected void preSave(ProductCategory entity, Long addedBy, Long editedBy) {
        if (addedBy != null) {
            entity.setAddedBy(addedBy);
            logger.info("Set addedBy: {}", addedBy);
        }
        if (editedBy != null) {
            entity.setEditedBy(editedBy);
            logger.info("Set editedBy: {}", editedBy);
        }
    }
}
