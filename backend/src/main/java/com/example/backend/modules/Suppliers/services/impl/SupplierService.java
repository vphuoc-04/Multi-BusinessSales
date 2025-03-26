package com.example.backend.modules.suppliers.services.impl;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.backend.helpers.FilterParameter;
import com.example.backend.modules.products.entities.Product;
import com.example.backend.modules.products.entities.ProductSupplier;
import com.example.backend.modules.products.repositories.ProductRepository;
import com.example.backend.modules.products.repositories.ProductSupplierRepository;
import com.example.backend.modules.suppliers.entities.Supplier;
import com.example.backend.modules.suppliers.repositories.SupplierRepository;
import com.example.backend.modules.suppliers.requests.Supplier.StoreRequest;
import com.example.backend.modules.suppliers.requests.Supplier.UpdateRequest;
import com.example.backend.modules.suppliers.services.interfaces.SupplierServiceInterface;
import com.example.backend.services.BaseService;
import com.example.backend.specifications.BaseSpecification;

@Service
public class SupplierService extends BaseService implements SupplierServiceInterface {
    private static final Logger logger = LoggerFactory.getLogger(SupplierService.class);

    @Autowired
    private SupplierRepository supplierRepository;

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private ProductSupplierRepository productSupplierRepository;

    @Override
    @Transactional
    public Supplier create(StoreRequest request, Long addedBy) {
        try {
            Supplier payload = Supplier.builder()
                .addedBy(addedBy)
                .name(request.getName())
                .build();

            Supplier supplier = supplierRepository.save(payload);

            if(request.getProductIds() != null && !request.getProductIds().isEmpty()) {
                List<ProductSupplier> productSuppliers = request.getProductIds().stream().map(productId -> {
                    Product product = productRepository.findById(productId)
                        .orElseThrow(() -> new RuntimeException("Product not found with ID: " + productId));

                    
                    ProductSupplier productSupplier = new ProductSupplier();
                    productSupplier.setProduct(product);
                    productSupplier.setSupplier(supplier);

                    return productSupplier;

                }).toList();

                productSupplierRepository.saveAll(productSuppliers);
            }

            return supplier;

        } catch (Exception e) {
            throw new RuntimeException("Transaction failed: " + e.getMessage());
        }
    }

    @Override
    @Transactional
    public Supplier update(Long id, UpdateRequest request, Long editedBy) {
        Supplier supplier = supplierRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Not found"));

        Supplier payload = supplier.toBuilder()
            .editedBy(editedBy)
            .name(request.getName())
            .build();

        return supplierRepository.save(payload);
    }

    @Override
    public Page<Supplier> paginate(Map<String, String[]> parameters) {
        int page = parameters.containsKey("page") ? Integer.parseInt(parameters.get("page")[0]) : 1;
        int perpage = parameters.containsKey("perpage") ? Integer.parseInt(parameters.get("perpage")[0]) : 10;
        String sortParam = parameters.containsKey("sort") ? parameters.get("sort")[0] : null;
        Sort sort = createSort(sortParam);

        String keyword = FilterParameter.filterKeyword(parameters);

        Map<String, String> filterSimple = FilterParameter.filterSimple(parameters);

        Map<String, Map<String, String>> filterComplex = FilterParameter.filterComplex(parameters);

        logger.info("Keyword: " + keyword);
        logger.info("Filter simple: {}", filterSimple );
        logger.info("Filter complex: {}", filterComplex);

        Specification<Supplier> specs = Specification.where(
            BaseSpecification.<Supplier>keywordSpec(keyword, "name")
        )
        .and(BaseSpecification.<Supplier>whereSpec(filterSimple))
        .and(BaseSpecification.<Supplier>complexWhereSpec(filterComplex));

        Pageable pageable = PageRequest.of(page - 1, perpage, sort);

        return supplierRepository.findAll(specs, pageable);
    }

    @Override
    @Transactional
    public boolean delete(Long id) {
        Supplier supplier = supplierRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Not found"));

        supplierRepository.delete(supplier);

        return true;
    }
}
