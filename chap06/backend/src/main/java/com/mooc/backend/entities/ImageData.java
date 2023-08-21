package com.mooc.backend.entities;

public record ImageData(
    String image,
    ImageLink link,
    String title
) implements BlockData {
}
