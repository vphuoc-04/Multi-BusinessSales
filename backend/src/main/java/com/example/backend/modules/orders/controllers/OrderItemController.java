package com.example.backend.modules.orders.controllers;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.backend.controllers.BaseController;
import com.example.backend.enums.PermissionEnum;
import com.example.backend.modules.orders.entities.OrderItem;
import com.example.backend.modules.orders.mappers.OrderItemMapper;
import com.example.backend.modules.orders.repositories.OrderItemRepository;
import com.example.backend.modules.orders.requests.OrderItem.StoreRequest;
import com.example.backend.modules.orders.requests.OrderItem.UpdateRequest;
import com.example.backend.modules.orders.resources.OrderItemResource;
import com.example.backend.modules.orders.services.interfaces.OrderItemServiceInterface;

@RestController
@RequestMapping("/api/v1/order_items")
public class OrderItemController extends BaseController<
    OrderItem,
    OrderItemResource,
    StoreRequest,
    UpdateRequest,
    OrderItemRepository
> {

    public OrderItemController(
        OrderItemServiceInterface orderItemService,
        OrderItemMapper orderItemMapper,
        OrderItemRepository orderItemRepository
    ) {
        super(orderItemService, orderItemMapper, orderItemRepository, PermissionEnum.ORDER_ITEM);
    }

    @Override
    protected String getStoreSuccessMessage() {
        return "Order item added successfully";
    }

    @Override
    protected String getUpdateSuccessMessage() {
        return "Order item updated successfully";
    }

    @Override
    protected String getFetchSuccessMessage() {
        return "Order items fetched successfully";
    }

    @Override
    protected String getDeleteSuccessMessage() {
        return "Order item removed successfully";
    }

    @Override
    protected String getEntityName() {
        return "Order item";
    }
}