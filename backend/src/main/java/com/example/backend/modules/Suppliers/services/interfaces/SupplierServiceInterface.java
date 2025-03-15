package com.example.backend.modules.suppliers.services.interfaces;

import java.util.Map;

import org.springframework.data.domain.Page;

import com.example.backend.modules.suppliers.entities.Supplier;
import com.example.backend.modules.suppliers.requests.Supplier.StoreRequest;
import com.example.backend.modules.suppliers.requests.Supplier.UpdateRequest;

public interface SupplierServiceInterface {
    Supplier create(StoreRequest request, Long addedBy);
    Supplier update(Long id, UpdateRequest request, Long editedBy);
    Page<Supplier> paginate(Map<String, String[]> parameters);
    boolean delete(Long id);
}
