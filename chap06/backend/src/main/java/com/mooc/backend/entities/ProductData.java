package com.mooc.backend.entities;

import java.util.Set;

public record ProductData(
    Long id,
    String sku,
    String name,
    String description,
    Set<String> images,
    String price,
    String originalPrice
) implements BlockData {
}
