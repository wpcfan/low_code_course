package com.mooc.backend.validators;

import jakarta.validation.Constraint;
import jakarta.validation.Payload;

import java.lang.annotation.*;

@Documented
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = {DateRangeValidator.class})
public @interface ValidateDateRange {

    String[] value() default {};

    String message() default "时间范围不合法";

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};
}
