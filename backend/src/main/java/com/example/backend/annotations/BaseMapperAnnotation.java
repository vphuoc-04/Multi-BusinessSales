package com.example.backend.annotations;

import java.lang.annotation.ElementType;
import org.mapstruct.Mapping;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;


@Retention(RetentionPolicy.CLASS)
@Target(ElementType.METHOD)
@Mapping(target = "id", ignore = true)
@Mapping(target = "createdAt", ignore= true)
@Mapping(target = "updatedAt", ignore= true)
@Mapping(target = "addedBy", ignore = true)
@Mapping(target = "editedBy", ignore = true)
public @interface BaseMapperAnnotation {
    
}