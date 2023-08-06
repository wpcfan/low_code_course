package com.mooc.backend.errors;

import jakarta.validation.ConstraintViolationException;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ProblemDetail;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

/**
 * 全局异常处理
 * Advice 是 AOP 的概念，表示切面，即在方法执行前后执行的代码
 */
@RestControllerAdvice
public class GlobalExceptionHandler {

    /**
     * ProblemDetail 是遵循 RFC7807 规范的错误响应体
     *
     * @param e
     * @return
     */
    @ExceptionHandler
    public ProblemDetail handleConstraintViolationException(ConstraintViolationException e) {
        ProblemDetail body = ProblemDetail
                .forStatusAndDetail(HttpStatusCode.valueOf(400), "参数错误");
        return body;
    }

}
