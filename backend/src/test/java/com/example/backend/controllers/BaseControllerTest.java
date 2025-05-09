package com.example.backend.controllers;

import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.ResultActions;

import com.example.backend.mappers.BaseMapper;
import com.example.backend.services.BaseServiceInterface;

public abstract class BaseControllerTest<
    Entity,
    Resource,
    Create,
    Update,
    Repository extends JpaRepository<Entity, Long> & JpaSpecificationExecutor<Entity>, 
    Mapper extends BaseMapper<Entity, Resource, Create, Update>,
    Service extends BaseServiceInterface<Entity, Create, Update>
>{
    @Autowired
    protected MockMvc mockMvc;

    @MockBean
    protected Service service;

    @MockBean
    protected Mapper mapper;

    protected abstract String getApiPath();
    protected abstract String getTestKeyword();
    protected abstract Map<String, String[]> getTestSimpleFilter();
    protected abstract ResultActions getExpectResponseData(ResultActions result, List<Resource> resource) throws Exception;
    protected abstract ResultActions getExpectResponseFilterData(ResultActions result, List<Resource> resource) throws Exception;
    protected abstract List<Entity> createTestEntities();
    protected abstract List<Entity> createTestEntitiesByKeywordFiltered(List<Entity> entities, String keyword);
    protected abstract List<Entity> createTestEntitiesBySimpleFiltered(List<Entity> entities, Map<String, String[]> filters);
    protected abstract List<Resource> createTestResources();
    protected abstract List<Resource> createTestResourcesByKeywordFiltered(List<Resource> resources, String keyword);
    protected abstract List<Resource> createTestResourcesBySimpleFiltered(List<Resource> resources, Map<String, String[]> filters);
}
