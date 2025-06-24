package com.example.backend.modules.orders.services.interfaces;

import com.example.backend.modules.orders.entities.Order;
import com.example.backend.modules.orders.requests.Order.StoreRequest;
import com.example.backend.modules.orders.requests.Order.UpdateRequest;
import com.example.backend.services.BaseServiceInterface;

public interface OrderServiceInterface extends BaseServiceInterface<Order, StoreRequest, UpdateRequest> {
    
}
