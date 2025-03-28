package com.example.backend.modules.products.mappers;

import org.mapstruct.Mapper;

import com.example.backend.mappers.BaseMapper;
import com.example.backend.modules.products.entities.ProductCategory;
import com.example.backend.modules.products.requests.ProductCategory.StoreRequest;
import com.example.backend.modules.products.requests.ProductCategory.UpdateRequest;
import com.example.backend.modules.products.resources.ProductCategoryResource;

@Mapper(componentModel = "spring")
public interface ProductCategoryMapper extends BaseMapper<ProductCategory, ProductCategoryResource, StoreRequest, UpdateRequest> {
    
}
