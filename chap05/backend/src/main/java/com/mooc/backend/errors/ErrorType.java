package com.mooc.backend.errors;

public enum ErrorType {
    FileUploadToQiniuException(40001),
    MethodArgumentTypeMismatchException(40002),
    CustomException(40003),
    ;

    private final int value;

    ErrorType(int value) {
        this.value = value;
    }

    public int getValue() {
        return value;
    }
}
