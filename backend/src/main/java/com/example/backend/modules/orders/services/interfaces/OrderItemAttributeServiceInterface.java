package com.example.backend.modules.orders.services.interfaces;

import com.example.backend.modules.orders.entities.OrderItemAttribute;
import com.example.backend.modules.orders.requests.OrderItemAttribute.StoreRequest;
import com.example.backend.modules.orders.requests.OrderItemAttribute.UpdateRequest;
import com.example.backend.services.BaseServiceInterface;

public interface OrderItemAttributeServiceInterface extends BaseServiceInterface<OrderItemAttribute, StoreRequest, UpdateRequest> {
}