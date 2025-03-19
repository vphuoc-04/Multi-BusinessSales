package com.example.backend.modules.products.repositories;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.backend.modules.products.entities.ProductImage;

@Repository
public interface ProductImageRepository extends JpaRepository<ProductImage, Long> {
    Optional<ProductImage> deleteByProductId(Long id);
}
