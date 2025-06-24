package com.example.backend.modules.orders.controllers;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.backend.controllers.BaseController;
import com.example.backend.enums.PermissionEnum;
import com.example.backend.modules.orders.entities.OrderItemAttribute;
import com.example.backend.modules.orders.mappers.OrderItemAttributeMapper;
import com.example.backend.modules.orders.repositories.OrderItemAttributeRepository;
import com.example.backend.modules.orders.requests.OrderItemAttribute.StoreRequest;
import com.example.backend.modules.orders.requests.OrderItemAttribute.UpdateRequest;
import com.example.backend.modules.orders.resources.OrderItemAttributeResource;
import com.example.backend.modules.orders.services.interfaces.OrderItemAttributeServiceInterface;

@RestController
@RequestMapping("/api/v1/order_item_attributes")
public class OrderItemAttributeController extends BaseController<
    OrderItemAttribute,
    OrderItemAttributeResource,
    StoreRequest,
    UpdateRequest,
    OrderItemAttributeRepository
> {

    public OrderItemAttributeController(
        OrderItemAttributeServiceInterface orderItemAttributeService,
        OrderItemAttributeMapper orderItemAttributeMapper,
        OrderItemAttributeRepository orderItemAttributeRepository
    ) {
        super(orderItemAttributeService, orderItemAttributeMapper, orderItemAttributeRepository, PermissionEnum.ORDER_ITEM_ATTRIBUTE);
    }

    @Override
    protected String getStoreSuccessMessage() {
        return "Order item attribute added successfully";
    }

    @Override
    protected String getUpdateSuccessMessage() {
        return "Order item attribute updated successfully";
    }

    @Override
    protected String getFetchSuccessMessage() {
        return "Order item attributes fetched successfully";
    }

    @Override
    protected String getDeleteSuccessMessage() {
        return "Order item attribute removed successfully";
    }

    @Override
    protected String getEntityName() {
        return "Order item attribute";
    }
}