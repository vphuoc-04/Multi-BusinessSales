package com.example.backend.controllers;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.example.backend.mappers.BaseMapper;
import com.example.backend.resources.ApiResource;
import com.example.backend.services.BaseServiceInterface;
import com.example.backend.services.JwtService;

import jakarta.persistence.EntityNotFoundException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;

public abstract class BaseController<
    Entity,
    Resource,
    Create,
    Update,
    Repository extends JpaRepository<Entity, Long> & JpaSpecificationExecutor<Entity>
>{
    protected final BaseServiceInterface<Entity, Create, Update> service;
    protected final BaseMapper<Entity, Resource, Create, Update> mapper;
    protected final Repository repository;

    @Autowired
    private JwtService jwtService;

    public BaseController(
        BaseServiceInterface<Entity, Create, Update> service,
        BaseMapper<Entity, Resource, Create, Update> mapper,
        Repository repository
    ){
        this.service = service;
        this.mapper = mapper;
        this.repository = repository;
    }

    @PostMapping
    public ResponseEntity<?> store(@Valid @RequestBody Create request, @RequestHeader("Authorization") String bearerToken) {
        try {
            Long userId = extractUserIdFromToken(bearerToken);
            Entity entity = service.add(request, userId);
            Resource resource = mapper.toResource(entity);
            ApiResource<Resource> response = ApiResource.ok(resource, getStoreSuccessMessage());

            return ResponseEntity.ok(response);
        } catch(Exception e) {
            return ResponseEntity.internalServerError().body(ApiResource.message("NETWORK_ERROR", HttpStatus.UNAUTHORIZED));
        } 
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> update(@PathVariable Long id, @Valid @RequestBody Update request, @RequestHeader("Authorization") String bearerToken) {
        try {
            Long userId = extractUserIdFromToken(bearerToken);
            Entity entity = service.edit(id, request, userId);
            Resource resource = mapper.toResource(entity);
            ApiResource<Resource> response = ApiResource.ok(resource, getUpdateSuccessMessage());
            return ResponseEntity.ok(response);
        } catch (EntityNotFoundException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                .body(ApiResource.error("NOT_FOUND", e.getMessage(), HttpStatus.NOT_FOUND));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(ApiResource.error("INTERNAL_SERVER_ERROR", "Error", HttpStatus.INTERNAL_SERVER_ERROR));
        }
    }

    @PostMapping(consumes = "multipart/form-data")
    public ResponseEntity<?> storeWithFiles(
        @Valid Create request,
        @RequestParam(value = "files", required = false) MultipartFile[] files,
        @RequestHeader("Authorization") String bearerToken
    ) {
        try {
            Long userId = extractUserIdFromToken(bearerToken);
            Create processedRequest = preStore(request);
            Entity entity = addWithFiles(processedRequest, files, userId); 
            Resource resource = mapper.toResource(entity);
            ApiResource<Resource> response = ApiResource.ok(resource, getStoreSuccessMessage());
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.internalServerError()
                .body(ApiResource.message(e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR));
        }
    }

    @PutMapping(value = "/{id}", consumes = "multipart/form-data")
    public ResponseEntity<?> updateWithFiles(
        @PathVariable Long id,
        @Valid Update request,
        @RequestParam(value = "files", required = false) MultipartFile[] files,
        @RequestHeader("Authorization") String bearerToken
    ) {
        try {
            Long userId = extractUserIdFromToken(bearerToken);
            Update processedRequest = preUpdate(request);
            Entity entity = editWithFiles(id, processedRequest, files, userId); 
            Resource resource = mapper.toResource(entity);
            ApiResource<Resource> response = ApiResource.ok(resource, getUpdateSuccessMessage());
            return ResponseEntity.ok(response);
        } catch (EntityNotFoundException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                .body(ApiResource.error("NOT_FOUND", e.getMessage(), HttpStatus.NOT_FOUND));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(ApiResource.message(e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR));
        }
    }

    @GetMapping
    public ResponseEntity<?> getAll(HttpServletRequest request) {
        Map<String, String[]> parameters = request.getParameterMap();
        Page<Entity> entities = service.paginate(parameters);
        Page<Resource> resources = mapper.toPageResource(entities);
        ApiResource<Page<Resource>> response = ApiResource.ok(resources, getFetchSuccessMessage());
        return ResponseEntity.ok(response);
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getById(@PathVariable Long id) {
        try {
            Entity entity = repository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException(getEntityName() + " not found with id: " + id));
            Resource resource = mapper.toResource(entity);
            ApiResource<Resource> response = ApiResource.ok(resource, getFetchByIdSuccessMessage());
            return ResponseEntity.ok(response);
        } catch (EntityNotFoundException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                .body(ApiResource.error("NOT_FOUND", e.getMessage(), HttpStatus.NOT_FOUND));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(ApiResource.error("INTERNAL_SERVER_ERROR", "Error", HttpStatus.INTERNAL_SERVER_ERROR));
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> delete(@PathVariable Long id) {
        try {
            boolean deleted = service.delete(id);
            if (deleted) {
                return ResponseEntity.ok(ApiResource.message(getDeleteSuccessMessage(), HttpStatus.OK));
            } else {
                return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(ApiResource.error("NOT_FOUND", "Error", HttpStatus.NOT_FOUND));
            }
        } catch (EntityNotFoundException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND)
                .body(ApiResource.error("NOT_FOUND", e.getMessage(), HttpStatus.NOT_FOUND));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(ApiResource.error("INTERNAL_SERVER_ERROR", "Error", HttpStatus.INTERNAL_SERVER_ERROR));
        }
    }

    protected long extractUserIdFromToken(String bearerToken) {
        String token = bearerToken.substring(7);
        String userId = jwtService.getUserIdFromJwt(token);
        return Long.valueOf(userId);
    }

    protected Create preStore(Create request) { return request; }
    protected Update preUpdate(Update request) { return request; }

    protected Entity addWithFiles(Create request, MultipartFile[] files, Long userId) {
        throw new UnsupportedOperationException("Method addWithFiles must be implemented by subclass if files are used");
    }

    protected Entity editWithFiles(Long id, Update request, MultipartFile[] files, Long userId) {
        throw new UnsupportedOperationException("Method editWithFiles must be implemented by subclass if files are used");
    }

    protected abstract String getStoreSuccessMessage();
    protected abstract String getUpdateSuccessMessage();
    protected abstract String getFetchSuccessMessage();
    protected abstract String getDeleteSuccessMessage();
    protected abstract String getEntityName();

    protected String getFetchByIdSuccessMessage() { return getEntityName() + " fetched successfully"; }

}
