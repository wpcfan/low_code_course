package com.mooc.backend.entities;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;

@JsonDeserialize(as = ImageData.class)
public record ImageData(
    String image,
    ImageLink link,
    String title
) implements BlockData {
}
