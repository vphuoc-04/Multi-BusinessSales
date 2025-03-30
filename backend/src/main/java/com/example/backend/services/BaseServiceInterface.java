package com.example.backend.services;

import java.util.Map;

import org.springframework.data.domain.Page;

public interface BaseServiceInterface<Entity, Create, Update> {
    Entity add(Create request, Long addedBy);
    Entity edit(Long id, Update request, Long editedBy);
    Page<Entity> paginate(Map<String, String[]> parameters);
    boolean delete(Long id);
}
