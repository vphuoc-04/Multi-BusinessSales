package com.example.backend.modules.products.mappers;

import com.example.backend.mappers.BaseMapper;
import com.example.backend.modules.products.entities.Product;
import com.example.backend.modules.products.requests.Product.StoreRequest;
import com.example.backend.modules.products.requests.Product.UpdateRequest;
import com.example.backend.modules.products.resources.ProductResource;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.ReportingPolicy;
import org.springframework.data.domain.Page;

@Mapper(
    unmappedTargetPolicy = ReportingPolicy.IGNORE,
    componentModel = "spring",
    uses = {ProductImageMapper.class, ProductBrandMapper.class}
)
public interface ProductMapper extends BaseMapper<Product, ProductResource, StoreRequest, UpdateRequest> {
    @Override
    @Mapping(target = "id", source = "id")
    @Mapping(target = "addedBy", source = "addedBy")
    @Mapping(target = "editedBy", source = "editedBy")
    @Mapping(target = "productCategoryId", source = "productCategoryId")
    @Mapping(target = "productCode", source = "productCode")
    @Mapping(target = "name", source = "name")
    @Mapping(target = "price", source = "price")
    @Mapping(target = "brandId", source = "brand", qualifiedByName = "toBrandId")
    @Mapping(target = "imageUrls", source = "images", qualifiedByName = "toImageUrls")
    ProductResource toResource(Product product);

    @Override
    default Page<ProductResource> toPageResource(Page<Product> products) {
        System.out.println("Mapping page of products: " + (products != null ? products.getTotalElements() : "null"));
        if (products == null) {
            return null;
        }
        return products.map(this::toResource);
    }
}