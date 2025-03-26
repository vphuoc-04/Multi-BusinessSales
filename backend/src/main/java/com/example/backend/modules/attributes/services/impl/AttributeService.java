package com.example.backend.modules.attributes.services.impl;

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
import com.example.backend.modules.attributes.entities.Attribute;
import com.example.backend.modules.attributes.repositories.AttributeRepository;
import com.example.backend.modules.attributes.requests.Attribute.StoreRequest;
import com.example.backend.modules.attributes.requests.Attribute.UpdateRequest;
import com.example.backend.modules.attributes.services.interfaces.AttributeServiceInterface;

import com.example.backend.services.BaseService;
import com.example.backend.specifications.BaseSpecification;

import jakarta.persistence.EntityNotFoundException;

@Service
public class AttributeService extends BaseService implements AttributeServiceInterface {
    private static final Logger logger = LoggerFactory.getLogger(AttributeService.class);

    @Autowired
    private AttributeRepository attributeRepository;

    @Override
    @Transactional
    public Attribute create(StoreRequest request, Long addedBy) {
        try {
            Attribute payload = Attribute.builder()
                .name(request.getName())
                .addedBy(addedBy)
                .build();
            
            return attributeRepository.save(payload);

        } catch (Exception e) {
            throw new RuntimeException("Transactional failed: " + e.getMessage());
        }
    }

    @Override
    @Transactional
    public Attribute update(Long id, UpdateRequest request, Long editedBy) {
        Attribute attribute = attributeRepository.findById(id)
            .orElseThrow(() -> new EntityNotFoundException("Attribute not found"));

        Attribute payload = attribute.toBuilder()
            .name(request.getName())
            .editedBy(editedBy)
            .build();

        return attributeRepository.save(payload);
    }

    @Override
    public Page<Attribute> paginate(Map<String, String[]> parameters) {
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

        Specification<Attribute> specs = Specification.where(
            BaseSpecification.<Attribute>keywordSpec(keyword, "name")
        )
        .and(BaseSpecification.<Attribute>whereSpec(filterSimple))
        .and(BaseSpecification.<Attribute>complexWhereSpec(filterComplex));

        Pageable pageable = PageRequest.of(page - 1, perpage, sort);

        return attributeRepository.findAll(specs, pageable);
    }

    @Override
    @Transactional
    public boolean delete(Long id) {
        Attribute attribute = attributeRepository.findById(id)
            .orElseThrow(() -> new EntityNotFoundException("Attribute not found"));

        attributeRepository.delete(attribute);

        return true;
    }
}
