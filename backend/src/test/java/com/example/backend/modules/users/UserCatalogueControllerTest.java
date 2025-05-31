package com.example.backend.modules.users;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import static org.hamcrest.Matchers.hasSize;
import static org.junit.jupiter.api.Assertions.fail;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.when;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.autoconfigure.orm.jpa.AutoConfigureDataJpa;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.FilterType;

import org.springframework.test.web.servlet.ResultActions;

import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import org.springframework.http.MediaType;

import com.example.backend.configs.SecurityConfig;
import com.example.backend.controllers.BaseControllerTest;
import com.example.backend.helpers.JwtAuthFilter;
import com.example.backend.modules.users.controllers.UserCatalogueController;
import com.example.backend.modules.users.entities.UserCatalogue;
import com.example.backend.modules.users.mappers.UserCatalogueMapper;
import com.example.backend.modules.users.repositories.PermissionRepository;
import com.example.backend.modules.users.repositories.UserCatalogueRepository;
import com.example.backend.modules.users.repositories.UserRepository;
import com.example.backend.modules.users.requests.UserCatalogue.StoreRequest;
import com.example.backend.modules.users.requests.UserCatalogue.UpdateRequest;
import com.example.backend.modules.users.resources.UserCatalogueResource;
import com.example.backend.modules.users.services.interfaces.UserCatalogueServiceInterface;
import com.example.backend.services.JwtService;

import jakarta.persistence.EntityNotFoundException;

@WebMvcTest(value = UserCatalogueController.class, excludeFilters= @ComponentScan.Filter(type=FilterType.ASSIGNABLE_TYPE, classes={JwtAuthFilter.class, SecurityConfig.class}))
@AutoConfigureMockMvc(addFilters=false)
@AutoConfigureDataJpa
public class UserCatalogueControllerTest extends BaseControllerTest<
    UserCatalogue,
    UserCatalogueResource,
    StoreRequest,
    UpdateRequest,
    UserCatalogueRepository,
    UserCatalogueMapper,
    UserCatalogueServiceInterface
> {
    @MockBean
    private JwtService jwtService;

    @MockBean
    private UserCatalogueServiceInterface userCatalogueService;

    @MockBean
    private UserCatalogueRepository userCatalogueRepository;

    @MockBean
    private PermissionRepository permissionRepository;

    @MockBean
    private UserRepository userRepository;

    @MockBean
    private UserCatalogueMapper userCatalogueMapper;

    @BeforeEach
    public void setup() {
        // Mock JWT validation to always return true for test token
        when(jwtService.isTokenExpired("test-token")).thenReturn(false);
        when(jwtService.isIssuerToken("test-token")).thenReturn(true);
        when(jwtService.isSignatureToken("test-token")).thenReturn(true);
        when(jwtService.isTokenFormatValid("test-token")).thenReturn(true);
        when(jwtService.isBlacklistedToken("test-token")).thenReturn(false);
        when(jwtService.getUserIdFromJwt("test-token")).thenReturn("1"); 
    }


    @Override
    protected String getApiPath(){
        return "/api/v1/user_catalogue";
    }

    @Override
    protected String getTestKeyword(){
        return "Admin";
    }

    protected boolean nameMatchesKeyword(String name, String keyword) {
        return name.toLowerCase().contains(keyword.toLowerCase());
    }

    @Override
    protected String getFetchSuccessMessage() {
        return "User catalogue fetch success";
    }

    @Override
    protected String getCreateSuccessMessage() {
        return "User catalogue added successfully";
    }

    @Override
    protected String getUpdateSuccessMessage() {
        return "User catalogue edited successfully";
    }

    @Override
    protected List<UserCatalogue> createTestEntities(){
        return Arrays.asList(
            UserCatalogue.builder()
                .id(1L)
                .name("Nhóm Admin")
                .publish(1)
                .createdAt(LocalDateTime.now())
                .build(),
            UserCatalogue.builder()
                .id(2L)
                .name("Nhóm Seller")
                .publish(1)
                .createdAt(LocalDateTime.now())
                .build(),
            UserCatalogue.builder()
                .id(3L)
                .name("Nhóm Cộng Tác Viên")
                .publish(2)
                .createdAt(LocalDateTime.now())
                .build(),
            UserCatalogue.builder()
                .id(4L)
                .name("Nhóm Admin hỗ trợ")
                .publish(2)
                .createdAt(LocalDateTime.now())
                .build()
        );
    }
    

    @Override
    protected List<UserCatalogueResource> createTestResources(){
        return Arrays.asList(
            UserCatalogueResource.builder()
                .id(1L)
                .name("Nhóm Admin")
                .publish(1)
                .build(),
            UserCatalogueResource.builder()
                .id(2L)
                .name("Nhóm Seller")
                .publish(1)
                .build(),
            UserCatalogueResource.builder()
                .id(3L)
                .name("Nhóm Cộng Tác Viên")
                .publish(2)
                .build(),
            UserCatalogueResource.builder()
                .id(4L)
                .name("Nhóm Admin Hỗ Trợ")
                .publish(1)
                .build()
        );
    }

    @Override
    protected List<UserCatalogue> createTestEntitiesByKeywordFiltered(List<UserCatalogue> entities, String keyword){
        String lowerCaseKeyword = keyword.toLowerCase();
        return entities.stream()
            .filter(entry -> entry.getName().toLowerCase().contains(lowerCaseKeyword))
            .collect(Collectors.toList());
    }

    @Override
    protected List<UserCatalogueResource> createTestResourcesByKeywordFiltered(List<UserCatalogueResource> resources, String keyword){
        String lowerCaseKeyword = keyword.toLowerCase();
        return resources.stream()
            .filter(entry -> entry.getName().toLowerCase().contains(lowerCaseKeyword))
            .collect(Collectors.toList());
    }

    @Override
    protected List<UserCatalogue> createTestEntitiesBySimpleFiltered(List<UserCatalogue> entities, Map<String, String[]> filters){
        return entities.stream()
            .filter(entry -> filters.entrySet().stream()
                .allMatch(param -> {
                    try {
                        String key = param.getKey(); // publish
                        String[] values = param.getValue();
                        String getterMethod = "get" + key.substring(0, 1).toUpperCase() + key.substring(1);
                        Method getter = entry.getClass().getMethod(getterMethod);
                        Object fieldValue = getter.invoke(entry);
                        if(fieldValue == null) return true;
                        return Arrays.stream(values).map(value -> fieldValue instanceof Integer ? Integer.valueOf(value) : value)
                            .allMatch(value -> value.equals(fieldValue));
                    } catch (NumberFormatException | NoSuchMethodException | InvocationTargetException | IllegalAccessException e) {
                        return true;
                    }
                })
            )
            .collect(Collectors.toList());
    }

    @Override
    protected List<UserCatalogueResource> createTestResourcesBySimpleFiltered(List<UserCatalogueResource> entities, Map<String, String[]> filters){
        return entities.stream()
        .filter(entry -> filters.entrySet().stream()
            .allMatch(param -> {
                try {
                    String key = param.getKey(); // publish
                    String[] values = param.getValue();
                    String getterMethod = "get" + key.substring(0, 1).toUpperCase() + key.substring(1);
                    Method getter = entry.getClass().getMethod(getterMethod);
                    Object fieldValue = getter.invoke(entry);
                    if(fieldValue == null) return true;
                    return Arrays.stream(values).map(value -> fieldValue instanceof Integer ? Integer.valueOf(value) : value)
                        .allMatch(value -> value.equals(fieldValue));
                } catch (NumberFormatException | NoSuchMethodException | InvocationTargetException | IllegalAccessException e) {
                    return true;
                }
            })
        )
        .collect(Collectors.toList());
    }

    @Override
    protected ResultActions getExpectResponseData(ResultActions result, List<UserCatalogueResource> resource) throws Exception {
        result.andExpect(jsonPath("$.data", hasSize(resource.size())));
        
        // Hiển thị response gốc
        System.out.println("\nOriginal Response:");
        result.andDo(print());
        
        // Lọc và hiển thị kết quả
        System.out.println("\nFiltered Results (Admin groups only):");
        String keyword = getTestKeyword().toLowerCase();
        resource.stream()
            .filter(r -> r.getName().toLowerCase().contains(keyword))
            .forEach(r -> System.out.println(
                "ID: " + r.getId() + 
                ", Name: " + r.getName() + 
                ", Publish: " + r.getPublish()));
        
        // Assert như bình thường
        for(int i = 0; i < resource.size(); i++){
            String name = resource.get(i).getName();
            if (!name.toLowerCase().contains(keyword)) {
                fail(String.format("Name '%s' does not contain keyword '%s'", name, keyword));
            }
            result.andExpect(jsonPath("$.data["+ i +"].id").value(resource.get(i).getId()))
                .andExpect(jsonPath("$.data["+ i +"].publish").value(resource.get(i).getPublish()));
        }
        
        return result;
    }

    @Override
    protected ResultActions getExpectResponseFilterData(ResultActions result, List<UserCatalogueResource> resource) throws  Exception{
       
        result.andExpect(jsonPath("$.data", hasSize(resource.size())));
        for(int i = 0; i < resource.size(); i++){
            result.andExpect(jsonPath("$.data["+ i +"].id").value(resource.get(i).getId()))
            .andExpect(jsonPath("$.data["+ i +"].name").value(resource.get(i).getName()))
            .andExpect(jsonPath("$.data["+ i +"].publish").value(resource.get(i).getPublish()));
        }

        return result;
    }


    @Override
    protected Map<String, String[]> getTestSimpleFilter(){
        Map<String, String[]> params = new HashMap<>();
        params.put("publish", new String[] {"1"});

        return params;
    }

    @Override
    protected StoreRequest createTestCreateRequest() {
        StoreRequest request = new StoreRequest();
        request.setName("Nhóm Test");
        request.setPublish(1);
        request.setPermissions(Arrays.asList(1L, 2L));
        request.setUsers(Arrays.asList(1L, 2L));
        return request;
    }

    @Override
    protected StoreRequest createInvalidTestCreateRequest() {
        StoreRequest request = new StoreRequest();
        request.setName("");
        request.setPublish(null);
        request.setPermissions(null);
        request.setUsers(null);
        return request;
    }

    @Test
    public void testCreateUserCatalogue() throws Exception {
        // Arrange
        StoreRequest storeRequest = createTestCreateRequest();
        UserCatalogue userCatalogue = UserCatalogue.builder()
            .id(1L)
            .name("Nhóm Test 1")
            .publish(1)
            .createdAt(LocalDateTime.now())
            .build();

        UserCatalogueResource userCatalogueResource = UserCatalogueResource.builder()
            .id(1L)
            .name("Nhóm Test 1")
            .publish(1)
            .build();

        when(userCatalogueService.add(any(StoreRequest.class), any(Long.class))).thenReturn(userCatalogue);
        when(userCatalogueMapper.toResource(any(UserCatalogue.class))).thenReturn(userCatalogueResource);

        // Act
        ResultActions result = mockMvc.perform(post(getApiPath())
            .header("Authorization", "Bearer test-token")
            .contentType(MediaType.APPLICATION_JSON)
            .characterEncoding("UTF-8")
            .content(objectMapper.writeValueAsString(storeRequest)));

        // Assert
        result.andDo(print())
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.message").value("User catalogue added successfully"))
            .andExpect(jsonPath("$.data.id").value(userCatalogueResource.getId()))
            .andExpect(jsonPath("$.data.name").value(userCatalogueResource.getName()))
            .andExpect(jsonPath("$.data.publish").value(userCatalogueResource.getPublish()))
            .andExpect(jsonPath("$.status").value("OK"))
            .andExpect(jsonPath("$.timestamp").isNotEmpty());
    }

    @Test
    public void testCreateUserCatalogue_WithInvalidData() throws Exception {
        // Arrange
        StoreRequest invalidRequest = createInvalidTestCreateRequest();

        // Act
        ResultActions result = mockMvc.perform(post(getApiPath())
            .header("Authorization", "Bearer test-token")
            .contentType(MediaType.APPLICATION_JSON)
            .characterEncoding("UTF-8")
            .content(objectMapper.writeValueAsString(invalidRequest)));

        // Assert
        result.andDo(print())
            .andExpect(status().isUnprocessableEntity())
            .andExpect(jsonPath("$.success").value(false))
            .andExpect(jsonPath("$.errors").exists());
    }


    @Override
    protected UpdateRequest createTestUpdateRequest() {
        UpdateRequest request = new UpdateRequest();
        request.setName("Nhóm Test Update");
        request.setPublish(1);
        request.setPermissions(Arrays.asList(1L, 2L));
        request.setUsers(Arrays.asList(1L, 2L));
        return request;
    }

    @Override
    protected UpdateRequest createInvalidTestUpdateRequest() {
        UpdateRequest request = new UpdateRequest();
        request.setName("");
        request.setPublish(null);
        request.setPermissions(null);
        request.setUsers(null);
        return request;
    }

    @Test
    public void testUpdateUserCatalogue() throws Exception {
        // Arrange
        Long catalogueId = 1L;
        UpdateRequest updateRequest = createTestUpdateRequest();
        UserCatalogue updatedUserCatalogue = UserCatalogue.builder()
            .id(catalogueId)
            .name("Nhóm Test Updated")
            .publish(1)
            .createdAt(LocalDateTime.now())
            .build();

        UserCatalogueResource updatedResource = UserCatalogueResource.builder()
            .id(catalogueId)
            .name("Nhóm Test Updated")
            .publish(1)
            .build();

        when(userCatalogueService.edit(eq(catalogueId), any(UpdateRequest.class), any(Long.class)))
            .thenReturn(updatedUserCatalogue);
        when(userCatalogueMapper.toResource(updatedUserCatalogue)).thenReturn(updatedResource);

        // Act
        ResultActions result = mockMvc.perform(put(getApiPath() + "/" + catalogueId)
            .header("Authorization", "Bearer test-token")
            .contentType(MediaType.APPLICATION_JSON)
            .characterEncoding("UTF-8")
            .content(objectMapper.writeValueAsString(updateRequest)));

        // Assert
        result.andDo(print())
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.message").value("User catalogue edited successfully"))
            .andExpect(jsonPath("$.data.id").value(updatedResource.getId()))
            .andExpect(jsonPath("$.data.name").value(updatedResource.getName()))
            .andExpect(jsonPath("$.data.publish").value(updatedResource.getPublish()))
            .andExpect(jsonPath("$.status").value("OK"))
            .andExpect(jsonPath("$.timestamp").isNotEmpty());
    }

    @Test
    public void testUpdateUserCatalogue_WithInvalidData() throws Exception {
        // Arrange
        Long catalogueId = 1L;
        UpdateRequest invalidRequest = createInvalidTestUpdateRequest();

        // Act
        ResultActions result = mockMvc.perform(put(getApiPath() + "/" + catalogueId)
            .header("Authorization", "Bearer test-token")
            .contentType(MediaType.APPLICATION_JSON)
            .characterEncoding("UTF-8")
            .content(objectMapper.writeValueAsString(invalidRequest)));

        // Assert
        result.andDo(print())
            .andExpect(status().isUnprocessableEntity())
            .andExpect(jsonPath("$.success").value(false))
            .andExpect(jsonPath("$.errors").exists());
    }

    @Test
    public void testUpdateUserCatalogue_NotFound() throws Exception {
        // Arrange
        Long nonExistentId = 999L;
        UpdateRequest updateRequest = createTestUpdateRequest();

        when(userCatalogueService.edit(eq(nonExistentId), any(UpdateRequest.class), any(Long.class)))
            .thenThrow(new EntityNotFoundException("User catalogue not found"));

        // Act
        ResultActions result = mockMvc.perform(put(getApiPath() + "/" + nonExistentId)
            .header("Authorization", "Bearer test-token")
            .contentType(MediaType.APPLICATION_JSON)
            .characterEncoding("UTF-8")
            .content(objectMapper.writeValueAsString(updateRequest)));

        // Assert
        result.andDo(print())
            .andExpect(status().isNotFound())
            .andExpect(jsonPath("$.success").value(false))
            .andExpect(jsonPath("$.status").value("NOT_FOUND"));
    }
}
