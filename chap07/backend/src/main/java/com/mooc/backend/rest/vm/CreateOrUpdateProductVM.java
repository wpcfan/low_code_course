package com.mooc.backend.rest.vm;

import java.math.BigDecimal;

public record CreateOrUpdateProductVM(
        String sku,
        String name,
        String description,
        BigDecimal price,
        BigDecimal originalPrice) {
}
