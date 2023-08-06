package com.mooc.backend.errors;

import jakarta.validation.ConstraintViolationException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ProblemDetail;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.context.request.WebRequest;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;

import java.net.URI;
import java.util.Objects;
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
    @ExceptionHandler(ConstraintViolationException.class)
    public ProblemDetail handleConstraintViolationException(
            ConstraintViolationException e,
            WebRequest request
    ) {
        ProblemDetail body = ProblemDetail
                .forStatusAndDetail(HttpStatusCode.valueOf(400), "参数错误");
        body.setType(URI.create(hostname + "/errors/constraint-violation-exception"));
        String title = e.getConstraintViolations().stream()
                .map(violation -> violation.getPropertyPath() + " " + violation.getMessage())
                .collect(Collectors.joining(";"));
        body.setTitle(title);
        body.setDetail(e.getMessage());
        body.setProperty("hostname", hostname);
        body.setProperty("user-agent", request.getHeader("User-Agent"));
        body.setProperty("locale", request.getLocale().toString());
        return body;
    }

    @ExceptionHandler(MethodArgumentTypeMismatchException.class)
    public ProblemDetail handleMethodArgumentTypeMismatchException(
            MethodArgumentTypeMismatchException e,
            WebRequest request
    ) {
        ProblemDetail body = ProblemDetail
                .forStatusAndDetail(HttpStatusCode.valueOf(400), "参数类型转换错误");
        body.setType(URI.create(hostname + "/errors/method-argument-type-mismatch-exception"));
        String title = "参数 " + e.getName() + " 类型应为 " + Objects.requireNonNull(e.getRequiredType()).getSimpleName() + "，但实际值为 " + e.getValue();
        body.setTitle(title);
        body.setDetail(e.getMessage());
        body.setProperty("hostname", hostname);
        body.setProperty("user-agent", request.getHeader("User-Agent"));
        body.setProperty("locale", request.getLocale().toString());
        return body;
    }

    @ExceptionHandler(Exception.class)
    public ProblemDetail handleException(
            Exception e,
            WebRequest request
    ) {
        ProblemDetail body = ProblemDetail
                .forStatusAndDetail(HttpStatusCode.valueOf(500), "服务器内部错误");
        body.setType(URI.create(hostname + "/errors/exception"));
        body.setTitle(e.getClass().getSimpleName());
        body.setDetail(e.getMessage());
        body.setProperty("hostname", hostname);
        body.setProperty("user-agent", request.getHeader("User-Agent"));
        body.setProperty("locale", request.getLocale().toString());
        return body;
    }

}
