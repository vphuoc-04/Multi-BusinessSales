package com.example.backend.modules.orders.services.impl;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.backend.modules.attributes.entities.AttributeValue;
import com.example.backend.modules.attributes.repositories.AttributeValueRepository;
import com.example.backend.modules.orders.entities.OrderItem;
import com.example.backend.modules.orders.entities.OrderItemAttribute;
import com.example.backend.modules.orders.mappers.OrderItemAttributeMapper;
import com.example.backend.modules.orders.repositories.OrderItemAttributeRepository;
import com.example.backend.modules.orders.repositories.OrderItemRepository;
import com.example.backend.modules.orders.requests.OrderItemAttribute.StoreRequest;
import com.example.backend.modules.orders.requests.OrderItemAttribute.UpdateRequest;
import com.example.backend.modules.orders.services.interfaces.OrderItemAttributeServiceInterface;
import com.example.backend.services.BaseService;

@Service
public class OrderItemAttributeService extends BaseService<
    OrderItemAttribute,
    OrderItemAttributeMapper,
    StoreRequest,
    UpdateRequest,
    OrderItemAttributeRepository
> implements OrderItemAttributeServiceInterface {
    private static final Logger logger = LoggerFactory.getLogger(OrderItemAttributeService.class);

    private final OrderItemAttributeMapper orderItemAttributeMapper;

    @Autowired
    private OrderItemAttributeRepository orderItemAttributeRepository;
    
    @Autowired
    private OrderItemRepository orderItemRepository;

    @Autowired
    private AttributeValueRepository attributeValueRepository;

    public OrderItemAttributeService(OrderItemAttributeMapper orderItemAttributeMapper) {
        this.orderItemAttributeMapper = orderItemAttributeMapper;
    }

    @Override
    protected String[] getSearchFields() {
        return new String[]{"attributeValue.value"};
    }

    @Override
    protected OrderItemAttributeRepository getRepository() {
        return orderItemAttributeRepository;
    }

    @Override
    protected OrderItemAttributeMapper getMapper() {
        return orderItemAttributeMapper;
    }

    @Override
    protected void preSave(OrderItemAttribute entity, Long addedBy, Long editedBy) {
        if (addedBy != null) {
            entity.setAddedBy(addedBy);
            logger.info("Set addedBy: {}", addedBy);
        }
        if (editedBy != null) {
            entity.setEditedBy(editedBy);
            logger.info("Set editedBy: {}", editedBy);
        }
    }

    @Override
    public OrderItemAttribute add(StoreRequest request, Long addedBy) {
        OrderItemAttribute entity = new OrderItemAttribute();

        // Lấy OrderItem
        OrderItem orderItem = orderItemRepository.findById(request.getOrderItemId())
            .orElseThrow(() -> new RuntimeException("OrderItem not found"));
        entity.setOrderItem(orderItem);

        // Lấy AttributeValue
        AttributeValue attributeValue = attributeValueRepository.findById(request.getAttributeValueId())
            .orElseThrow(() -> new RuntimeException("Attribute value not found"));
        entity.setAttributeValue(attributeValue);

        // Gán addedBy
        entity.setAddedBy(addedBy);

        return orderItemAttributeRepository.save(entity);
    }
}