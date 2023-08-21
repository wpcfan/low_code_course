package com.mooc.backend.entities;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;

import java.util.Set;

@JsonDeserialize(as = ProductData.class)
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
