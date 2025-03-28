package com.example.backend.modules.products.mappers;

import com.example.backend.modules.products.entities.ProductImage;
import org.mapstruct.Mapper;
import org.mapstruct.Named;

import java.util.List;
import java.util.Objects;

@Mapper(componentModel = "spring")
public interface ProductImageMapper {
    @Named("toImageUrls")
    default List<String> toImageUrls(List<ProductImage> images) {
        if (images == null) {
            return List.of(); 
        }
        return images.stream()
            .map(ProductImage::getImageUrl) 
            .filter(Objects::nonNull) 
            .toList();
    }
}