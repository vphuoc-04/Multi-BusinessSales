package com.example.backend.modules.products.services.interfaces;

import com.example.backend.modules.products.entities.ProductCategory;
import com.example.backend.modules.products.requests.ProductCategory.StoreRequest;
import com.example.backend.modules.products.requests.ProductCategory.UpdateRequest;
import com.example.backend.services.BaseServiceInterface;

public interface ProductCategoryServiceInterface extends BaseServiceInterface<ProductCategory, StoreRequest, UpdateRequest> {

}
