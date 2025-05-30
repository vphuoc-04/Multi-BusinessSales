package com.example.backend.controllers;

import java.util.List;
import java.util.Map;

import static org.assertj.core.api.Assertions.assertThat;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.ResultActions;
import org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.example.backend.mappers.BaseMapper;
import com.example.backend.services.BaseServiceInterface;
import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.http.HttpServletRequest;

public abstract class BaseControllerTest<
    Entity,
    Resource,
    Create,
    Update,
    Repository extends JpaRepository<Entity, Long> & JpaSpecificationExecutor<Entity>, 
    Mapper extends BaseMapper<Entity, Resource, Create, Update>,
    Service extends BaseServiceInterface<Entity, Create, Update>
> {
    @Autowired
    protected MockMvc mockMvc;

    @Autowired
    protected ObjectMapper objectMapper;

    @MockBean
    protected Service service;

    @MockBean
    protected Mapper mapper;

    protected String getFetchSuccessMessage() {
        return "SUCCESS";
    }

    protected String getCreateSuccessMessage() {
        return "SUCCESS";
    }

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
    protected abstract Create createTestCreateRequest();
    protected abstract Create createInvalidTestCreateRequest();

    @Test
    void list_NoFilter_ShouldReturnAllRecords() throws Exception {
        List<Entity> mockEntities = createTestEntities();
        List<Resource> mockResources = createTestResources();

        @SuppressWarnings("unchecked")
        ArgumentCaptor<Map<String, String[]>> captor = ArgumentCaptor.forClass(Map.class);

        when(service.getAll(captor.capture(), any(HttpServletRequest.class))).thenReturn(mockEntities);
        when(mapper.toListResource(mockEntities)).thenReturn(mockResources);

        mockMvc.perform(get(getApiPath() + "/list")
                .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.message").value(getFetchSuccessMessage()))
                .andExpect(jsonPath("$.status").value("OK"))
                .andExpect(jsonPath("$.data").isArray())
                .andExpect(jsonPath("$.timestamp").exists())
                .andExpect(jsonPath("$.errors").doesNotExist())
                .andExpect(jsonPath("$.error").doesNotExist());

        verify(service).getAll(captor.capture(), any(HttpServletRequest.class));
        verify(mapper).toListResource(mockEntities);

        Map<String, String[]> capturedParams = captor.getValue();
        assertThat(capturedParams).isNotNull();
        assertThat(capturedParams).isEmpty();
    }

    @Test
    void list_withKeywordFilter_ShouldReturnFilteredKeywordRecords() throws Exception {
        List<Entity> mockEntities = createTestEntities();
        List<Resource> mockResources = createTestResources();
        List<Entity> mockFilterEntities = createTestEntitiesByKeywordFiltered(mockEntities, getTestKeyword());
        List<Resource> mockFilterResources = createTestResourcesByKeywordFiltered(mockResources, getTestKeyword());

        @SuppressWarnings("unchecked")
        ArgumentCaptor<Map<String, String[]>> captor = ArgumentCaptor.forClass(Map.class);

        when(service.getAll(captor.capture(), any(HttpServletRequest.class))).thenReturn(mockFilterEntities);
        when(mapper.toListResource(mockFilterEntities)).thenReturn(mockFilterResources);

        ResultActions actions = mockMvc.perform(get(getApiPath() + "/list")
                .param("keyword", getTestKeyword())
                .contentType(MediaType.APPLICATION_JSON));

        getExpectResponseData(actions, mockFilterResources)
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.message").value(getFetchSuccessMessage()))
                .andExpect(jsonPath("$.status").value("OK"))
                .andExpect(jsonPath("$.data").isArray())
                .andExpect(jsonPath("$.timestamp").exists())
                .andExpect(jsonPath("$.errors").doesNotExist())
                .andExpect(jsonPath("$.error").doesNotExist());

        verify(service).getAll(captor.capture(), any(HttpServletRequest.class));
        verify(mapper).toListResource(mockFilterEntities);

        Map<String, String[]> capturedParams = captor.getValue();
        assertThat(capturedParams).isNotNull();
        assertThat(capturedParams.get("keyword")).containsExactly(getTestKeyword());
    }

    @Test
    void list_withSimpleFilter_ShouldReturnSimpleFilteredRecords() throws Exception {
        Map<String, String[]> filters = getTestSimpleFilter();
        List<Entity> mockEntities = createTestEntities();
        List<Resource> mockResources = createTestResources();
        List<Entity> mockFilterEntities = createTestEntitiesBySimpleFiltered(mockEntities, filters);
        List<Resource> mockFilterResources = createTestResourcesBySimpleFiltered(mockResources, filters);

        @SuppressWarnings("unchecked")
        ArgumentCaptor<Map<String, String[]>> captor = ArgumentCaptor.forClass(Map.class);

        when(service.getAll(captor.capture(), any(HttpServletRequest.class))).thenReturn(mockFilterEntities);
        when(mapper.toListResource(mockFilterEntities)).thenReturn(mockFilterResources);

        MockHttpServletRequestBuilder requestBuilder = get(getApiPath() + "/list");
        filters.forEach((key, values) -> {
            for (String value : values) {
                requestBuilder.param(key, value);
            }
        });
        ResultActions actions = mockMvc.perform(requestBuilder.contentType(MediaType.APPLICATION_JSON))
            .andDo(print());

        getExpectResponseFilterData(actions, mockFilterResources)
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.message").value(getFetchSuccessMessage()))
            .andExpect(jsonPath("$.status").value("OK"))
            .andExpect(jsonPath("$.data").isArray())
            .andExpect(jsonPath("$.timestamp").exists())
            .andExpect(jsonPath("$.errors").doesNotExist())
            .andExpect(jsonPath("$.error").doesNotExist());

        Map<String, String[]> capturedParams = captor.getValue();
        assertThat(capturedParams).isNotNull();
        filters.forEach((key, values) -> {
            assertThat(capturedParams).containsKey(key);
            assertThat(capturedParams.get(key)).containsExactly(values);
        });

        verify(service).getAll(eq(capturedParams), any(HttpServletRequest.class));
        verify(mapper).toListResource(mockFilterEntities);
    }

    @Test
    void create_ShouldReturnCreatedRecord() throws Exception {
        // Arrange
        Create createRequest = createTestCreateRequest();
        List<Entity> mockEntities = createTestEntities();
        List<Resource> mockResources = createTestResources();
        Entity mockEntity = mockEntities.get(0);
        Resource mockResource = mockResources.get(0);

        when(service.add(any(), any(Long.class))).thenReturn(mockEntity);
        when(mapper.toResource(mockEntity)).thenReturn(mockResource);

        // Act
        ResultActions actions = mockMvc.perform(post(getApiPath())
            .header("Authorization", "Bearer test-token")
            .contentType(MediaType.APPLICATION_JSON)
            .characterEncoding("UTF-8")
            .content(objectMapper.writeValueAsString(createRequest)));

        // Assert
        actions.andDo(print())
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.message").value(getCreateSuccessMessage()))
            .andExpect(jsonPath("$.data.id").exists())
            .andExpect(jsonPath("$.data.name").exists())
            .andExpect(jsonPath("$.data.publish").exists())
            .andExpect(jsonPath("$.status").value("OK"))
            .andExpect(jsonPath("$.timestamp").exists())
            .andExpect(jsonPath("$.errors").doesNotExist())
            .andExpect(jsonPath("$.error").doesNotExist());

        verify(service).add(any(), any(Long.class));
        verify(mapper).toResource(mockEntity);
    }

    @Test
    void create_WithInvalidData_ShouldReturnUnprocessableEntity() throws Exception {
        // Arrange
        Create invalidRequest = createInvalidTestCreateRequest();

        // Act
        ResultActions actions = mockMvc.perform(post(getApiPath())
            .header("Authorization", "Bearer test-token")
            .contentType(MediaType.APPLICATION_JSON)
            .characterEncoding("UTF-8")
            .content(objectMapper.writeValueAsString(invalidRequest)));

        // Assert
        actions.andDo(print())
            .andExpect(status().isUnprocessableEntity())
            .andExpect(jsonPath("$.success").value(false))
            .andExpect(jsonPath("$.errors").exists());
    }
}