package com.example.backend.modules.products.controllers;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.backend.controllers.BaseController;
import com.example.backend.modules.products.entities.ProductBrand;
import com.example.backend.modules.products.mappers.ProductBrandMapper;
import com.example.backend.modules.products.repositories.ProductBrandRepository;
import com.example.backend.modules.products.requests.ProductBrand.StoreRequest;
import com.example.backend.modules.products.requests.ProductBrand.UpdateRequest;
import com.example.backend.modules.products.resources.ProductBrandResource;
import com.example.backend.modules.products.services.interfaces.ProductBrandServiceInterface;

@RestController
@RequestMapping("api/v1/product_brand")
public class ProductBrandController extends BaseController<
    ProductBrand,
    ProductBrandResource,
    StoreRequest,
    UpdateRequest,
    ProductBrandRepository
> { 
    public ProductBrandController(
        ProductBrandServiceInterface productBrandService,
        ProductBrandMapper productBrandMapper,
        ProductBrandRepository productBrandRepository
    ){
        super(productBrandService, productBrandMapper, productBrandRepository);
    }

    @Override
    protected String getStoreSuccessMessage() {
        return "Product brand added successfully";
    }

    @Override
    protected String getUpdateSuccessMessage() {
        return "Product brand edited successfully";
    }

    @Override
    protected String getFetchSuccessMessage() {
        return "Product brand fetch success";
    }

    @Override
    protected String getDeleteSuccessMessage() {
        return "Product brand deleted successfully";
    }

    @Override
    protected String getEntityName() {
        return "Product brand";
    }
}
