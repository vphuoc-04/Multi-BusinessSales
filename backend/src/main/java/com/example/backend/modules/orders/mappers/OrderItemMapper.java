package com.example.backend.modules.orders.mappers;

import com.example.backend.mappers.BaseMapper;
import com.example.backend.modules.orders.entities.OrderItem;
import com.example.backend.modules.orders.requests.OrderItem.StoreRequest;
import com.example.backend.modules.orders.requests.OrderItem.UpdateRequest;
import com.example.backend.modules.orders.resources.OrderItemResource;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.ReportingPolicy;
import org.springframework.data.domain.Page;

@Mapper(
    unmappedTargetPolicy = ReportingPolicy.IGNORE,
    componentModel = "spring",
    uses = {OrderItemAttributeMapper.class}
)
public interface OrderItemMapper extends BaseMapper<OrderItem, OrderItemResource, StoreRequest, UpdateRequest> {
    @Override
    @Mapping(target = "id", source = "id")
    @Mapping(target = "orderId", source = "order.id")
    @Mapping(target = "productId", source = "product.id")
    @Mapping(target = "quantity", source = "quantity")
    @Mapping(target = "unitPrice", source = "unitPrice")
    @Mapping(target = "attributes", source = "attributes")
    OrderItemResource toResource(OrderItem orderItem);

    @Override
    default Page<OrderItemResource> toPageResource(Page<OrderItem> orderItems) {
        if (orderItems == null) {
            return null;
        }
        return orderItems.map(this::toResource);
    }
}