package com.example.backend.modules.attributes.repositories;

import com.example.backend.modules.attributes.entities.Attribute;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface AttributeRepository extends JpaRepository<Attribute, Long>, JpaSpecificationExecutor<Attribute> {
    Optional<Attribute> findById(long id);
}
