package com.mooc.backend.entities;

public record CategoryData(
    Long id,
    String name,
    String code
) implements BlockData {
}
