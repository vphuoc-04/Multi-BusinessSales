package com.example.backend.modules.orders.services.interfaces;

import com.example.backend.modules.orders.entities.OrderItem;
import com.example.backend.modules.orders.requests.OrderItem.StoreRequest;
import com.example.backend.modules.orders.requests.OrderItem.UpdateRequest;
import com.example.backend.services.BaseServiceInterface;

public interface OrderItemServiceInterface extends BaseServiceInterface<OrderItem, StoreRequest, UpdateRequest> {
}