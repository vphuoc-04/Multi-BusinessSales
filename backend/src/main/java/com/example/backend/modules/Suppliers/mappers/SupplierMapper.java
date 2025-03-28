package com.example.backend.modules.suppliers.mappers;

import org.mapstruct.Mapper;

import com.example.backend.mappers.BaseMapper;
import com.example.backend.modules.suppliers.entities.Supplier;
import com.example.backend.modules.suppliers.requests.Supplier.StoreRequest;
import com.example.backend.modules.suppliers.requests.Supplier.UpdateRequest;
import com.example.backend.modules.suppliers.resources.SupplierResource;

@Mapper(componentModel = "spring")
public interface SupplierMapper extends BaseMapper<Supplier, SupplierResource, StoreRequest, UpdateRequest> {
    
}
