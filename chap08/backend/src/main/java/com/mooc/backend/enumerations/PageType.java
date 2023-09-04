package com.mooc.backend.enumerations;

public enum PageType {
    Home("首页"),
    Category("分类页"),
    About("关于页"),;

    private final String value;

    PageType(String value) {
        this.value = value;
    }
}
