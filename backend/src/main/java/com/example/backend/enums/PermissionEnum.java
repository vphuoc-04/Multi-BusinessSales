package com.example.backend.enums;

public enum PermissionEnum {
    USER("users"),
    USER_CATALOGUE("user_catalogues"),
    PRODUCT("products"),
    PRODUCT_BRAND("product_brands"),
    PRODUCT_CATEGORY("product_categories"),
    ATTRIBUTE("attributes"),
    ATTRIBUTE_VALUE("attribute_values"),
    PERMISSION("permissions");
    

    private final String prefix;

    PermissionEnum(String prefix) {
        this.prefix = prefix;
    }

    public String getPrefix() {
        return prefix;
    }
}
