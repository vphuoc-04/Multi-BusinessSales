package com.example.backend.modules.products.services.impl;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.backend.modules.products.entities.ProductBrand;
import com.example.backend.modules.products.mappers.ProductBrandMapper;
import com.example.backend.modules.products.repositories.ProductBrandRepository;
import com.example.backend.modules.products.requests.ProductBrand.StoreRequest;
import com.example.backend.modules.products.requests.ProductBrand.UpdateRequest;
import com.example.backend.modules.products.services.interfaces.ProductBrandServiceInterface;
import com.example.backend.services.BaseService;

@Service
public class ProductBrandService extends BaseService<
    ProductBrand,
    ProductBrandMapper,
    StoreRequest,
    UpdateRequest,
    ProductBrandRepository
>implements ProductBrandServiceInterface {
    private static final Logger logger = LoggerFactory.getLogger(ProductBrandService.class);
    private final ProductBrandMapper productBrandMapper;

    @Autowired
    private ProductBrandRepository productBrandRepository;

    public ProductBrandService(
        ProductBrandMapper productBrandMapper
    ){
        this.productBrandMapper = productBrandMapper;
    }

    @Override
    protected String[] getSearchFields() {
        return new String[]{"name"};
    }

    @Override
    protected ProductBrandRepository getRepository() {
        return productBrandRepository;
    }

    @Override 
    protected ProductBrandMapper getMapper() {
        return productBrandMapper;
    }

    @Override
    protected void preSave(ProductBrand entity, Long addedBy, Long editedBy) {
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
