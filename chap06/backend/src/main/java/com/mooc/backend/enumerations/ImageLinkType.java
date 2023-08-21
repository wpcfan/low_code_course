package com.mooc.backend.enumerations;

public enum ImageLinkType {
    Url("url"),
    Route("route");

    private final String value;

    ImageLinkType(String value) {
        this.value = value;
    }
}
