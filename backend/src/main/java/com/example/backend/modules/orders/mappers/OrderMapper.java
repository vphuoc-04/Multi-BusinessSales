package com.example.backend.modules.orders.mappers;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.ReportingPolicy;
import org.springframework.data.domain.Page;

import com.example.backend.mappers.BaseMapper;
import com.example.backend.modules.orders.entities.Order;
import com.example.backend.modules.orders.requests.Order.StoreRequest;
import com.example.backend.modules.orders.requests.Order.UpdateRequest;
import com.example.backend.modules.orders.resources.OrderResource;

@Mapper(
    unmappedTargetPolicy = ReportingPolicy.IGNORE,
    componentModel = "spring",
    uses = {OrderItemMapper.class}
)
public interface OrderMapper extends BaseMapper<Order, OrderResource, StoreRequest, UpdateRequest> {
    @Override
    @Mapping(target = "id", source = "id")
    @Mapping(target = "userId", source = "user.id")
    @Mapping(target = "addedBy", source = "addedBy")
    @Mapping(target = "editedBy", source = "editedBy")
    @Mapping(target = "orderDate", source = "orderDate")
    @Mapping(target = "status", source = "status")
    @Mapping(target = "totalAmount", source = "totalAmount")
    @Mapping(target = "items", source = "orderItems")
    OrderResource toResource(Order order);

    @Override
    default Page<OrderResource> toPageResource(Page<Order> orders) {
        if (orders == null) {
            return null;
        }
        return orders.map(this::toResource);
    }
}
