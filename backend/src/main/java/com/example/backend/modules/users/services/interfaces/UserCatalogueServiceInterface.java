package com.example.backend.modules.users.services.interfaces;

import com.example.backend.modules.users.entities.UserCatalogue;
import com.example.backend.modules.users.requests.UserCatalogue.StoreRequest;

public interface UserCatalogueServiceInterface {
    UserCatalogue create(StoreRequest request);
}
