package com.example.backend.modules.orders.services.impl;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.backend.modules.orders.entities.Order;
import com.example.backend.modules.orders.mappers.OrderMapper;
import com.example.backend.modules.orders.repositories.OrderRepository;
import com.example.backend.modules.orders.requests.Order.StoreRequest;
import com.example.backend.modules.orders.requests.Order.UpdateRequest;
import com.example.backend.modules.orders.services.interfaces.OrderServiceInterface;
import com.example.backend.services.BaseService;

@Service
public class OrderService extends BaseService<
    Order,
    OrderMapper,
    StoreRequest,
    UpdateRequest,
    OrderRepository
> implements OrderServiceInterface {
    private static final Logger logger = LoggerFactory.getLogger(OrderService.class);

    private final OrderMapper orderMapper;

    @Autowired
    private OrderRepository orderRepository;

    public OrderService(OrderMapper orderMapper) {
        this.orderMapper = orderMapper;
    }

    @Override
    protected String[] getSearchFields() {
        return new String[]{"status"};
    }

    @Override
    protected OrderRepository getRepository() {
        return orderRepository;
    }

    @Override
    protected OrderMapper getMapper() {
        return orderMapper;
    }

    @Override
    protected void preSave(Order entity, Long addedBy, Long editedBy) {
        if (addedBy != null) {
            entity.setAddedBy(addedBy);
            logger.info("Set addedBy: {}", addedBy);
        }
        if (editedBy != null) {
            entity.setEditedBy(editedBy);
            logger.info("Set editedBy: {}", editedBy);
        }
    }
}