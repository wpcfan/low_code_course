package com.mooc.backend.enumerations;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;

public enum ImageLinkType {
    Url("url"),
    Route("route");

    private final String value;

    ImageLinkType(String value) {
        this.value = value;
    }

    @JsonCreator
    public static ImageLinkType fromValue(String value) {
        for (ImageLinkType type : ImageLinkType.values()) {
            if (type.value.equals(value)) {
                return type;
            }
        }
        throw new IllegalArgumentException("Unknown enum type " + value);
    }

    @JsonValue
    public String getValue() {
        return value;
    }
}
