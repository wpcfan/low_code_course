package com.mooc.backend.errors;

import jakarta.validation.ConstraintViolationException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ProblemDetail;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.net.URI;
import java.util.stream.Collectors;

/**
 * 全局异常处理
 * Advice 是 AOP 的概念，表示切面，即在方法执行前后执行的代码
 */
@RestControllerAdvice
public class GlobalExceptionHandler {

    @Value("${hostname}")
    String hostname;

    /**
     * 用于处理 ConstraintViolationException 异常
     * ProblemDetail 是遵循 RFC7807 规范的错误响应体
     *
     * @param e ConstraintViolationException 是 Jakarta Validation 的异常
     * @return ProblemDetail
     */
    @ExceptionHandler
    public ProblemDetail handleConstraintViolationException(ConstraintViolationException e) {
        ProblemDetail body = ProblemDetail
                .forStatusAndDetail(HttpStatusCode.valueOf(400), "参数错误");
        body.setType(URI.create(hostname + "/errors/constraint-violation-exception"));
        String title = e.getConstraintViolations().stream()
                .map(violation -> violation.getPropertyPath() + " " + violation.getMessage())
                .collect(Collectors.joining(";"));
        body.setTitle(title);
        body.setDetail(e.getMessage());
        body.setProperty("hostname", hostname);
        return body;
    }

}
