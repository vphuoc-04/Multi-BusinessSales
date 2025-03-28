package com.example.backend.modules.users.services.impl;

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
import com.example.backend.modules.users.entities.UserCatalogue;
import com.example.backend.modules.users.mappers.UserCatalogueMapper;
import com.example.backend.modules.users.repositories.UserCatalogueRepository;
import com.example.backend.modules.users.requests.UserCatalogue.StoreRequest;
import com.example.backend.modules.users.requests.UserCatalogue.UpdateRequest;
import com.example.backend.modules.users.services.interfaces.UserCatalogueServiceInterface;
import com.example.backend.services.BaseService;
import com.example.backend.specifications.BaseSpecification;

import jakarta.persistence.EntityNotFoundException;

@Service
public class UserCatalogueService extends BaseService implements UserCatalogueServiceInterface {
    private static final Logger logger = LoggerFactory.getLogger(UserCatalogueService.class);
    private final UserCatalogueMapper userCatalogueMapper;

    @Autowired
    private UserCatalogueRepository userCataloguesRepository;

    public UserCatalogueService(
        UserCatalogueMapper userCatalogueMapper
    ){
        this.userCatalogueMapper = userCatalogueMapper;
    }

    @Override
    @Transactional
    public UserCatalogue create(StoreRequest request, Long addedBy) {
        try {
            UserCatalogue payload = userCatalogueMapper.toCreate(request);
            payload.setAddedBy(addedBy);

            return userCataloguesRepository.save(payload);
        } catch (Exception e) {
            throw new RuntimeException("Transaction failed: " + e.getMessage());
        }
    }  

    @Override
    public Page<UserCatalogue> paginate(Map<String, String[]> parameters) {
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

        Specification<UserCatalogue> specs = Specification.where(
            BaseSpecification.<UserCatalogue>keywordSpec(keyword, "name")
        )
        .and(BaseSpecification.<UserCatalogue>whereSpec(filterSimple))
        .and(BaseSpecification.<UserCatalogue>complexWhereSpec(filterComplex));

        Pageable pageable = PageRequest.of(page - 1, perpage, sort);

        return userCataloguesRepository.findAll(specs, pageable);
    }

    @Override
    @Transactional
    public UserCatalogue update(Long id, UpdateRequest request, Long editedBy) {
        UserCatalogue userCatalogue = userCataloguesRepository.findById(id)
            .orElseThrow(() -> new EntityNotFoundException("User catalogue not found"));

        userCatalogueMapper.toUpdate(request, userCatalogue);
        userCatalogue.setEditedBy(editedBy);

        return userCataloguesRepository.save(userCatalogue);
    }

    @Override
    @Transactional
    public boolean delete(Long id) {
        UserCatalogue userCatalogue = userCataloguesRepository.findById(id)
            .orElseThrow(() -> new EntityNotFoundException("User catalogue not found"));

        userCataloguesRepository.delete(userCatalogue);
        return true;
    }
}