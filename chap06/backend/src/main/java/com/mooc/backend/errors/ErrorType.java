package com.mooc.backend.errors;

import lombok.Getter;

@Getter
public enum ErrorType {
    QiniuFileUploadException(40001),
    QiniuFileListException(40002),
    QiniuFileDeleteException(40003),
    FileUploadIOException(40004),
    ResourcesNotFoundException(40005),
    ;

    private final int value;

    ErrorType(int value) {
        this.value = value;
    }
}
