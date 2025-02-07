package com.example.backend.modules.users.repositories;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.backend.modules.users.entities.UserCatalogue;

public interface UserCatalogueRepository extends JpaRepository<UserCatalogue, Long> {
    Optional<UserCatalogue> findById(Long id);
}
