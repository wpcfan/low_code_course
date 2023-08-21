package com.mooc.backend.entities;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import lombok.*;

import java.io.Serial;
import java.io.Serializable;

@Data
@Schema(description = "页面配置")
public class PageConfig implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;
    @Schema(description = "页面基准宽度", example = "375")
    @Min(value = 300, message = "不能小于 300")
    @Max(value = 1920, message = "不能大于 1920")
    private Double baselineScreenWidth;
}
