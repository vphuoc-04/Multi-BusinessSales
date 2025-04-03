package com.example.backend.services;

import java.lang.reflect.Field;
import java.lang.reflect.ParameterizedType;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
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

import org.springframework.context.ApplicationContext;

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

    @Autowired
    private ApplicationContext applicationContext;

    protected abstract String[] getSearchFields();
    protected String[] getRelations() { return new String[0]; }
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
        Entity entity = getRepository().save(payload);

        Long relationId = getRelationIdFromCreate(request);
        if (relationId != null) { setRelation(payload, relationId); }
        handleManyToManyRelations(entity, request);
        preSave(payload, addedBy, null); 
        return entity;
    }

    @Transactional
    public Entity edit(Long id, Update request, Long editedBy) {
        Entity entity = getRepository().findById(id)
            .orElseThrow(() -> new EntityNotFoundException("Not found"));
        getMapper().toUpdate(request, entity);
        Entity update = getRepository().save(entity);

        Long relationId = getRelationIdFromUpdate(request);
        if (relationId != null) { setRelation(entity, relationId); }
        handleManyToManyRelations(entity, request);
        preSave(entity, null, editedBy);
        return update;
    }

    @Transactional
    public boolean delete(Long id) {
        Entity entity = getRepository().findById(id)
            .orElseThrow(() -> new EntityNotFoundException("Not found"));
        getRepository().delete(entity);
        return true;
    }

    public List<Entity> getAll(Map<String, String[]> parameters) {
        Sort sort = parseSort(parameters);
        Specification<Entity> specs = buildSpecification(parameters, getSearchFields());
        return getRepository().findAll(specs, sort);
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

    private void handleManyToManyRelations(Entity entity, Object request) {
        String[] relations = getRelations();
        if (relations != null && relations.length > 0) {
            for(String relation: relations){
                try {
                    Field requestField = request.getClass().getDeclaredField(relation);
                    requestField.setAccessible(true);
                    @SuppressWarnings("unchecked")
                    List<Long> ids = (List<Long>) requestField.get(request);
                    if(ids != null && !ids.isEmpty()){
                        Field entityField = entity.getClass().getDeclaredField(relation);
                        entityField.setAccessible(true);
                        ParameterizedType setType = (ParameterizedType) entityField.getGenericType();
                        Class<?> entityClass = (Class<?>) setType.getActualTypeArguments()[0];
                        String repositoryName = entityClass.getSimpleName() + "Repository";
                        repositoryName = Character.toLowerCase(repositoryName.charAt(0)) + repositoryName.substring(1);
                        
                        @SuppressWarnings("unchecked")
                        JpaRepository<Entity, Long> repository = (JpaRepository<Entity, Long>) applicationContext.getBean(repositoryName);
                        List<Entity> entities = repository.findAllById(ids);
                        Set<Entity> entitySet = new HashSet<>(entities);
                        entityField.set(entity, entitySet);
                    }
                    
                }catch ( NoSuchFieldException | ClassCastException | IllegalAccessException  e) {
                    throw new RuntimeException("An error occurred while processing the relationship: " + relation + " " + e.getMessage(), e);
                }
            }
        }
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
