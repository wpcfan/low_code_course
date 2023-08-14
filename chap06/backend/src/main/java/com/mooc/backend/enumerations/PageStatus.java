package com.mooc.backend.enumerations;

public enum PageStatus {
    DRAFT("草稿"),
    PUBLISHED("已发布"),
    ARCHIVED("已归档");

    private final String value;

    PageStatus(String value) {
        this.value = value;
    }

    public String getValue() {
        return value;
    }
}
