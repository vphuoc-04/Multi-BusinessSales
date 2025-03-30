package com.example.backend.modules.products.controllers;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.backend.controllers.BaseController;
import com.example.backend.modules.products.entities.ProductCategory;
import com.example.backend.modules.products.mappers.ProductCategoryMapper;
import com.example.backend.modules.products.repositories.ProductCategoryRepository;
import com.example.backend.modules.products.requests.ProductCategory.StoreRequest;
import com.example.backend.modules.products.requests.ProductCategory.UpdateRequest;
import com.example.backend.modules.products.resources.ProductCategoryResource;
import com.example.backend.modules.products.services.interfaces.ProductCategoryServiceInterface;

@RestController
@RequestMapping("api/v1/product_category")
public class ProductCategoryController extends BaseController<
    ProductCategory,
    ProductCategoryResource,
    StoreRequest,
    UpdateRequest,
    ProductCategoryRepository
> {
    public ProductCategoryController(
        ProductCategoryServiceInterface productCategoryService,
        ProductCategoryMapper productCategoryMapper,
        ProductCategoryRepository productCategoryRepository
    ){
        super(productCategoryService, productCategoryMapper, productCategoryRepository);
    }

    @Override
    protected String getStoreSuccessMessage() {
        return "Product category added successfully";
    }

    @Override
    protected String getUpdateSuccessMessage() {
        return "Product category edited successfully";
    }

    @Override
    protected String getFetchSuccessMessage() { 
        return "Product category fetch success";
    }

    @Override
    protected String getDeleteSuccessMessage() {
        return "Product category deleted successfully";
    }

    @Override
    protected String getEntityName() {
        return "Product category";
    }
}
