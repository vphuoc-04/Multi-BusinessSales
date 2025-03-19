package com.example.backend.modules.products.services.impl;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.backend.modules.products.entities.ProductBrand;
import com.example.backend.modules.products.repositories.ProductBrandRepository;
import com.example.backend.modules.products.requests.ProductBrand.StoreRequest;
import com.example.backend.modules.products.requests.ProductBrand.UpdateRequest;
import com.example.backend.modules.products.services.interfaces.ProductBrandServiceInterface;
import com.example.backend.services.BaseService;

import jakarta.persistence.EntityNotFoundException;

@Service
public class ProductBrandService extends BaseService implements ProductBrandServiceInterface {
    @Autowired
    private ProductBrandRepository productBrandRepository;

    @Override
    @Transactional
    public ProductBrand create(StoreRequest request, Long addedBy) {
        try {
            ProductBrand payload = ProductBrand.builder()
                .name(request.getName())
                .addedBy(addedBy)
                .build();

            return productBrandRepository.save(payload);
            
        } catch (Exception e) {
            throw new RuntimeException("Transaction failed: " + e.getMessage());
        }
    }

    @Override
    @Transactional
    public ProductBrand update(Long id, UpdateRequest request, Long editedBy) {
        ProductBrand productBrand = productBrandRepository.findById(id)
            .orElseThrow(() -> new EntityNotFoundException("Not found"));

        ProductBrand payload = productBrand.toBuilder()
            .name(request.getName())
            .editedBy(editedBy)
            .build();

        return productBrandRepository.save(payload);
    }

    @Override
    public Page<ProductBrand> paginate(Map<String, String[]> parameters) {
        int page = parameters.containsKey("page") ? Integer.parseInt(parameters.get("page")[0]) : 1;
        int perpage = parameters.containsKey("perpage") ? Integer.parseInt(parameters.get("perpage")[0]) : 10;
        String sortParam = parameters.containsKey("sort") ? parameters.get("sort")[0] : null;
        Sort sort = createSort(sortParam);

        Pageable pageable = PageRequest.of(page - 1, perpage, sort);

        return productBrandRepository.findAll(pageable);
    }

    @Override
    @Transactional
    public boolean delete(Long id) {
        ProductBrand productBrand = productBrandRepository.findById(id)
            .orElseThrow(() -> new EntityNotFoundException("Not found"));

        productBrandRepository.delete(productBrand);

        return true;
    }
}
