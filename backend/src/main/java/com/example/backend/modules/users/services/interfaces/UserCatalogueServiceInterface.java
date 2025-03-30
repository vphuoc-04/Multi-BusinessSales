package com.example.backend.modules.users.services.interfaces;

import com.example.backend.modules.users.entities.UserCatalogue;
import com.example.backend.modules.users.requests.UserCatalogue.StoreRequest;
import com.example.backend.modules.users.requests.UserCatalogue.UpdateRequest;
import com.example.backend.services.BaseServiceInterface;

public interface UserCatalogueServiceInterface extends BaseServiceInterface<UserCatalogue, StoreRequest, UpdateRequest> {

}
