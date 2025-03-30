package com.example.backend.modules.products.services.interfaces;


import com.example.backend.modules.products.entities.ProductBrand;
import com.example.backend.modules.products.requests.ProductBrand.StoreRequest;
import com.example.backend.modules.products.requests.ProductBrand.UpdateRequest;
import com.example.backend.services.BaseServiceInterface;

public interface ProductBrandServiceInterface extends BaseServiceInterface<ProductBrand, StoreRequest, UpdateRequest> {

}
