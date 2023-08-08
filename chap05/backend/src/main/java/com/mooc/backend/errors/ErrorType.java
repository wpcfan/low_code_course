package com.mooc.backend.errors;

public enum ErrorType {
    QiniuFileUploadException(40001),
    QiniuFileListException(40002),
    QiniuFileDeleteException(40003),
    ;

    private final int value;

    ErrorType(int value) {
        this.value = value;
    }

    public int getValue() {
        return value;
    }
}
