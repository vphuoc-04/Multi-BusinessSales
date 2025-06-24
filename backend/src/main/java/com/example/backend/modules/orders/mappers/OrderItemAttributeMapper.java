package com.example.backend.modules.orders.mappers;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.ReportingPolicy;
import org.springframework.data.domain.Page;

import com.example.backend.mappers.BaseMapper;
import com.example.backend.modules.orders.entities.OrderItemAttribute;
import com.example.backend.modules.orders.requests.OrderItemAttribute.StoreRequest;
import com.example.backend.modules.orders.requests.OrderItemAttribute.UpdateRequest;
import com.example.backend.modules.orders.resources.OrderItemAttributeResource;

@Mapper(
    unmappedTargetPolicy = ReportingPolicy.IGNORE,
    componentModel = "spring"
)
public interface OrderItemAttributeMapper extends BaseMapper<OrderItemAttribute, OrderItemAttributeResource, StoreRequest, UpdateRequest> {
    @Override
    @Mapping(target = "id", source = "id")
    @Mapping(target = "attributeValueId", source = "attributeValue.id")
    OrderItemAttributeResource toResource(OrderItemAttribute orderItemAttribute);

    @Override
    default Page<OrderItemAttributeResource> toPageResource(Page<OrderItemAttribute> orderItemAttributes) {
        if (orderItemAttributes == null) {
            return null;
        }
        return orderItemAttributes.map(this::toResource);
    }
}