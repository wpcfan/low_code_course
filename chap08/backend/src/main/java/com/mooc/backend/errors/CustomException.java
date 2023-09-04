package com.mooc.backend.errors;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public class CustomException extends RuntimeException {
    private final String message;
    private final String detail;
    private final ErrorType code;
}
