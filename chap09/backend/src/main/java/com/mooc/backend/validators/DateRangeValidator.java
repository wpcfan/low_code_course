package com.mooc.backend.validators;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.constraintvalidation.SupportedValidationTarget;
import jakarta.validation.constraintvalidation.ValidationTarget;
import org.springframework.expression.spel.standard.SpelExpressionParser;

import java.time.LocalDateTime;

@SupportedValidationTarget({ValidationTarget.ANNOTATED_ELEMENT})
public class DateRangeValidator implements ConstraintValidator<ValidateDateRange, Object> {
    private static final SpelExpressionParser PARSER = new SpelExpressionParser();
    private String[] fields;

    @Override
    public void initialize(ValidateDateRange constraintAnnotation) {
        this.fields = constraintAnnotation.value();
    }

    @Override
    public boolean isValid(Object value, jakarta.validation.ConstraintValidatorContext context) {
        if (fields.length != 2) {
            throw new IllegalArgumentException("时间范围校验器需要两个字段");
        }
        LocalDateTime startTime = (LocalDateTime) PARSER.parseExpression(fields[0]).getValue(value);
        LocalDateTime endTime = (LocalDateTime) PARSER.parseExpression(fields[1]).getValue(value);
        if (startTime == null || endTime == null) {
            return true;
        }
        return startTime.isBefore(endTime);
    }
}
