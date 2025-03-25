package com.example.backend.modules.attributes.repositories;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.example.backend.modules.attributes.entities.AttributeValue;

@Repository
public interface AttributeValueRepository extends JpaRepository<AttributeValue, Long> {
    Optional<AttributeValue> findById(long id);

    @Query("SELECT av FROM AttributeValue av WHERE av.attribute.id = :attributeId")
    List<AttributeValue> findByAttributeId(@Param("attributeId") Long attributeId);
}
