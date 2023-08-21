package com.mooc.backend.entities;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;

@JsonDeserialize(as = CategoryData.class)
public record CategoryData(
    Long id,
    String name,
    String code
) implements BlockData {
}
