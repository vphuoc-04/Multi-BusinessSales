package com.example.backend.services;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.backend.helpers.FilterParameter;
import com.example.backend.mappers.BaseMapper;
import com.example.backend.specifications.BaseSpecification;

import jakarta.persistence.EntityNotFoundException;

@Service
public abstract class BaseService <
    Entity,
    Mapper extends BaseMapper<Entity, ?, Create, Update>,
    Create,
    Update,
    Repository extends JpaRepository<Entity, Long> & JpaSpecificationExecutor<Entity>
> {
    private static final Logger logger = LoggerFactory.getLogger(BaseService.class);

    protected abstract String[] getSearchFields();
    protected abstract Repository getRepository();
    protected abstract Mapper getMapper();
    protected Long getRelationIdFromCreate(Create request) { return null; }
    protected Long getRelationIdFromUpdate(Update request) { return null; }
    protected void setRelation(Entity entity, Long relationId) {}
    protected void preSave(Entity entity, Long addedBy, Long editedBy) {}

    @Transactional
    public Entity add(Create request, Long addedBy) {
        logger.info("Creating with addedBy: {}", addedBy);
        Entity payload = getMapper().toCreate(request);

        Long relationId = getRelationIdFromCreate(request);
        if (relationId != null) {
            setRelation(payload, relationId);
        }

        preSave(payload, addedBy, null); 
        return getRepository().save(payload);
    }

    @Transactional
    public Entity edit(Long id, Update request, Long editedBy) {
        Entity entity = getRepository().findById(id)
            .orElseThrow(() -> new EntityNotFoundException("Not found"));
        getMapper().toUpdate(request, entity);

        Long relationId = getRelationIdFromUpdate(request);
        if (relationId != null) {
            setRelation(entity, relationId);
        }

        preSave(entity, null, editedBy);
        return getRepository().save(entity);
    }

    @Transactional
    public boolean delete(Long id) {
        Entity entity = getRepository().findById(id)
            .orElseThrow(() -> new EntityNotFoundException("Not found"));
        getRepository().delete(entity);
        return true;
    }

    public Page<Entity> paginate(Map<String, String[]> parameters) {
        int page = parameters.containsKey("page") ? Integer.parseInt(parameters.get("page")[0]) : 1;
        int perpage = parameters.containsKey("perpage") ? Integer.parseInt(parameters.get("perpage")[0]) : 10;
        Sort sort = parseSort(parameters);
        Specification<Entity> specs = buildSpecification(parameters, getSearchFields());
        Pageable pageable = PageRequest.of(page - 1, perpage, sort);
        return getRepository().findAll(specs, pageable);
    }

    public Page<Entity> paginate(Long filterId, Map<String, String[]> parameters) {
        int page = parameters.containsKey("page") ? Integer.parseInt(parameters.get("page")[0]) : 1;
        int perpage = parameters.containsKey("perpage") ? Integer.parseInt(parameters.get("perpage")[0]) : 10;
        Sort sort = parseSort(parameters);
        Specification<Entity> baseSpec = buildSpecification(parameters, getSearchFields());
        Specification<Entity> filterSpec = filterId != null ? 
            (root, query, cb) -> cb.equal(root.get("catalogueId"), filterId) : 
            null;
        Specification<Entity> finalSpec = filterSpec != null ? baseSpec.and(filterSpec) : baseSpec;
        Pageable pageable = PageRequest.of(page - 1, perpage, sort);
        return getRepository().findAll(finalSpec, pageable);
    }

    protected Specification<Entity> buildSpecification(Map<String, String[]> parameters, String[] searchFields) {
        String keyword = FilterParameter.filterKeyword(parameters);
        Map<String, String> filterSimple = FilterParameter.filterSimple(parameters);
        Map<String, Map<String, String>> filterComplex = FilterParameter.filterComplex(parameters);

        Specification<Entity> specs = Specification.where(
            BaseSpecification.<Entity>keywordSpec(keyword, searchFields) 
        )
        .and(BaseSpecification.<Entity>whereSpec(filterSimple))
        .and(BaseSpecification.<Entity>complexWhereSpec(filterComplex));

        return specs;
    }

    protected Sort createSort(String sortParam) {
        if (sortParam == null || sortParam.isEmpty()) {
            return Sort.by(Sort.Order.desc("id"));
        }

        String[] parts = sortParam.split(",");
        String field = parts[0];
        String sortDirection = (parts.length > 1) ? parts[1] : "asc";

        if ("desc".equalsIgnoreCase(sortDirection)) {
            return Sort.by(Sort.Order.desc(field));
        } else {
            return Sort.by(Sort.Order.asc(field));
        }
    }

    protected Sort parseSort(Map<String, String[]> parameters) {
        String sortParam = parameters.containsKey("sort") ? parameters.get("sort")[0] : null;
        return createSort(sortParam);
    } 
}
