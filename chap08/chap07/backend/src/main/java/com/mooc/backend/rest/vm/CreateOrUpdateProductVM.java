package com.mooc.backend.rest.vm;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.*;

import java.math.BigDecimal;

@Schema(description = "创建或更新商品的视图模型")
public record CreateOrUpdateProductVM(
        @Schema(description = "商品 SKU", example = "sku_123456")
        @NotNull(message = "SKU 不能为空")
        @Size(min = 2, max = 50, message = "SKU 长度必须在 2 ~ 50 个字符之间")
        String sku,
        @Schema(description = "商品名称", example = "iPhone 12")
        @NotNull(message = "商品名称不能为空")
        @Size(min = 2, max = 255, message = "商品名称长度必须在 2 ~ 255 个字符之间")
        String name,
        @Schema(description = "商品描述", example = "iPhone 12 256G")
        @Size(max = 255, message = "商品描述不能超过 255 个字符")
        String description,
        @Schema(description = "商品价格", example = "5999.00")
        @NotNull(message = "商品价格不能为空")
        @Min(value = 0, message = "商品价格必须大于等于 0")
        @Max(value = 99999999, message = "商品价格必须小于等于 99999999")
        BigDecimal price,
        @Schema(description = "商品原价", example = "6999.00")
        @Min(value = 0, message = "商品价格必须大于等于 0")
        @Max(value = 99999999, message = "商品价格必须小于等于 99999999")
        BigDecimal originalPrice) {
}
