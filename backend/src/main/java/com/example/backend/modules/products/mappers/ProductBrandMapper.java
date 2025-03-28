package com.example.backend.modules.products.mappers;

import com.example.backend.mappers.BaseMapper;
import com.example.backend.modules.products.entities.ProductBrand;
import com.example.backend.modules.products.requests.ProductBrand.StoreRequest;
import com.example.backend.modules.products.requests.ProductBrand.UpdateRequest;
import com.example.backend.modules.products.resources.ProductBrandResource;
import org.mapstruct.Mapper;
import org.mapstruct.Named;

@Mapper(componentModel = "spring")
public interface ProductBrandMapper extends BaseMapper<ProductBrand, ProductBrandResource, StoreRequest, UpdateRequest> {
    @Named("toBrandId")
    default Long toBrandId(ProductBrand productBrand) {
        return productBrand != null ? productBrand.getId() : null;
    }
}