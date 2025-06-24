package com.example.backend.modules.orders.services.impl;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.backend.modules.orders.entities.Order;
import com.example.backend.modules.orders.entities.OrderItem;
import com.example.backend.modules.orders.mappers.OrderItemMapper;
import com.example.backend.modules.orders.repositories.OrderItemRepository;
import com.example.backend.modules.orders.repositories.OrderRepository;
import com.example.backend.modules.orders.requests.OrderItem.StoreRequest;
import com.example.backend.modules.orders.requests.OrderItem.UpdateRequest;
import com.example.backend.modules.orders.services.interfaces.OrderItemServiceInterface;
import com.example.backend.modules.products.entities.Product;
import com.example.backend.modules.products.repositories.ProductRepository;
import com.example.backend.services.BaseService;

@Service
public class OrderItemService extends BaseService<
    OrderItem,
    OrderItemMapper,
    StoreRequest,
    UpdateRequest,
    OrderItemRepository
> implements OrderItemServiceInterface {
    private static final Logger logger = LoggerFactory.getLogger(OrderItemService.class);

    private final OrderItemMapper orderItemMapper;

    @Autowired
    private OrderItemRepository orderItemRepository;
    
    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private ProductRepository productRepository;    

    public OrderItemService(OrderItemMapper orderItemMapper) {
        this.orderItemMapper = orderItemMapper;
    }

    @Override
    protected String[] getSearchFields() {
        return new String[]{"product.name"};
    }

    @Override
    protected OrderItemRepository getRepository() {
        return orderItemRepository;
    }

    @Override
    protected OrderItemMapper getMapper() {
        return orderItemMapper;
    }

    @Override
    protected void preSave(OrderItem entity, Long addedBy, Long editedBy) {
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
    public OrderItem add(StoreRequest request, Long addedBy) {
        OrderItem orderItem = new OrderItem();

        Order order = orderRepository.findById(request.getOrderId())
            .orElseThrow(() -> new RuntimeException("Order not found"));

        orderItem.setOrder(order); 

        Product product = productRepository.findById(request.getProductId())
            .orElseThrow(() -> new RuntimeException("Product not found"));
        orderItem.setProduct(product);

        orderItem.setQuantity(request.getQuantity());
        orderItem.setUnitPrice(request.getUnitPrice());
        orderItem.setAddedBy(addedBy);

        return orderItemRepository.save(orderItem);
    }
}