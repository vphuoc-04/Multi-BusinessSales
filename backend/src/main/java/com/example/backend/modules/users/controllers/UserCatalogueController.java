package com.example.backend.modules.users.controllers;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.backend.modules.users.entities.UserCatalogue;
import com.example.backend.modules.users.mappers.UserCatalogueMapper;
import com.example.backend.modules.users.requests.UserCatalogue.StoreRequest;
import com.example.backend.modules.users.requests.UserCatalogue.UpdateRequest;
import com.example.backend.modules.users.resources.UserCatalogueResource;
import com.example.backend.modules.users.services.interfaces.UserCatalogueServiceInterface;
import com.example.backend.resources.ApiResource;
import com.example.backend.services.JwtService;

import jakarta.persistence.EntityNotFoundException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;

@RestController
@RequestMapping("api/v1")
public class UserCatalogueController {
    private final UserCatalogueServiceInterface userCatagoluesService;
    private final UserCatalogueMapper userCatalogueMapper;

    @Autowired
    private JwtService jwtService;

    public UserCatalogueController(
        UserCatalogueServiceInterface userCatagoluesService,
        UserCatalogueMapper userCatalogueMapper,
        JwtService jwtService
    ){
        this.userCatagoluesService = userCatagoluesService;
        this.userCatalogueMapper = userCatalogueMapper;
        this.jwtService = jwtService;
    }

    @PostMapping("/user_catalogue")
    public ResponseEntity<?> store(@Valid @RequestBody StoreRequest request, @RequestHeader("Authorization") String bearerToken) {
        try {
            String token = bearerToken.substring(7);
            String userId = jwtService.getUserIdFromJwt(token);
            Long createdBy = Long.valueOf(userId);

            UserCatalogue userCatalogue = userCatagoluesService.create(request, createdBy);
            UserCatalogueResource userCatalogueResource = userCatalogueMapper.toResource(userCatalogue);
            ApiResource<UserCatalogueResource> response = ApiResource.ok(userCatalogueResource, "New user catalogue added successfully");

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body(ApiResource.message("Network error", HttpStatus.UNAUTHORIZED));
        }
    }

    @GetMapping("/user_catalogue")
    public ResponseEntity<?> index(HttpServletRequest request) {
        Map<String, String[]> parameters = request.getParameterMap();
        Page<UserCatalogue> userCatalogues = userCatagoluesService.paginate(parameters);
        Page<UserCatalogueResource> userCatalogueResource = userCatalogueMapper.toPageResource(userCatalogues);
        ApiResource<Page<UserCatalogueResource>> response = ApiResource.ok(userCatalogueResource, "User catalogue data fetched successfully");
        return ResponseEntity.ok(response);
    }

    @PutMapping("/user_catalogue/{id}")
    public ResponseEntity<?> update(@PathVariable Long id, @Valid @RequestBody UpdateRequest request, @RequestHeader("Authorization") String bearerToken) {
        try {
            String token = bearerToken.substring(7);
            String userId = jwtService.getUserIdFromJwt(token);
            Long updatedBy = Long.valueOf(userId);

            UserCatalogue userCatalogue = userCatagoluesService.update(id, request, updatedBy);
            UserCatalogueResource userCatalogueResource = userCatalogueMapper.toResource(userCatalogue);
            ApiResource<UserCatalogueResource> response = ApiResource.ok(userCatalogueResource, "User catalogue updated successfully");

            return ResponseEntity.ok(response);
        } catch (EntityNotFoundException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(
                ApiResource.error("NOT_FOUND", e.getMessage(), HttpStatus.NOT_FOUND)
            );
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(
                ApiResource.error("INTERNAL_SERVER_ERROR", "Error", HttpStatus.INTERNAL_SERVER_ERROR)
            );
        }   
    }

    @DeleteMapping("/user_catalogue/{id}")
    public ResponseEntity<?> delete(@PathVariable Long id) {
        try {
            boolean deleted = userCatagoluesService.delete(id);

            if (deleted) {
                return ResponseEntity.ok(
                    ApiResource.message("User catalogue deleted successfully", HttpStatus.OK)
                );
            } else {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(
                    ApiResource.error("NOT_FOUND", "Error", HttpStatus.NOT_FOUND)
                );
            }

        } catch (EntityNotFoundException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(
                ApiResource.error("NOT_FOUND", e.getMessage(), HttpStatus.NOT_FOUND)
            );
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(
                ApiResource.error("INTERNAL_SERVER_ERROR", "Error", HttpStatus.INTERNAL_SERVER_ERROR)
            );
        }   
    }
}
