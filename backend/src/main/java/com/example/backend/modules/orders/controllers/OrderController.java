package com.example.backend.modules.orders.controllers;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.backend.controllers.BaseController;
import com.example.backend.enums.PermissionEnum;
import com.example.backend.modules.orders.entities.Order;
import com.example.backend.modules.orders.mappers.OrderMapper;
import com.example.backend.modules.orders.repositories.OrderRepository;
import com.example.backend.modules.orders.requests.Order.StoreRequest;
import com.example.backend.modules.orders.requests.Order.UpdateRequest;
import com.example.backend.modules.orders.resources.OrderResource;
import com.example.backend.modules.orders.services.interfaces.OrderServiceInterface;

@RestController
@RequestMapping("/api/v1/orders")
public class OrderController extends BaseController<
    Order,
    OrderResource,
    StoreRequest,
    UpdateRequest,
    OrderRepository
> {

    public OrderController(
        OrderServiceInterface orderService,
        OrderMapper orderMapper,
        OrderRepository orderRepository
    ) {
        super(orderService, orderMapper, orderRepository, PermissionEnum.ORDER);
    }

    @Override
    protected String getStoreSuccessMessage() {
        return "Order created successfully";
    }

    @Override
    protected String getUpdateSuccessMessage() {
        return "Order updated successfully";
    }

    @Override
    protected String getFetchSuccessMessage() {
        return "Orders fetched successfully";
    }

    @Override
    protected String getDeleteSuccessMessage() {
        return "Order deleted successfully";
    }

    @Override
    protected String getEntityName() {
        return "Order";
    }
}