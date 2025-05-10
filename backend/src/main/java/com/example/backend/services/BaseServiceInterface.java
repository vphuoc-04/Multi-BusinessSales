package com.example.backend.services;

import java.util.List;
import java.util.Map;

import org.springframework.data.domain.Page;

import jakarta.servlet.http.HttpServletRequest;

public interface BaseServiceInterface<Entity, Create, Update> {
    Entity add(Create request, Long addedBy);
    Entity edit(Long id, Update request, Long editedBy);
    List<Entity> getAll(Map<String, String[]> parameters, HttpServletRequest request);
    Page<Entity> paginate(Map<String, String[]> parameters, HttpServletRequest request);
    boolean delete(Long id);
}
