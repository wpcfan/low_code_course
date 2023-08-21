package com.mooc.backend.entities;

import com.mooc.backend.enumerations.ImageLinkType;

public record ImageLink(
    ImageLinkType type,
    String value
) {
}
