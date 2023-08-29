package com.mooc.backend.entities;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import io.swagger.v3.oas.annotations.media.Schema;

import java.util.Set;

@Schema(description = "商品区块数据")
@JsonDeserialize(as = ProductData.class)
public record ProductData(
    @Schema(description = "商品 ID", example = "1")
    Long id,
    @Schema(description = "商品 SKU", example = "sku_001")
    String sku,
    @Schema(description = "商品名称", example = "xPhone手机")
    String name,
    @Schema(description = "商品描述", example = "这是一段商品描述")
    String description,
    @Schema(description = "商品图片", example = "[\"https://picsum.photos/200/300\"]")
    Set<String> images,
    @Schema(description = "商品价格", example = "¥1234.00")
    String price,
    @Schema(description = "商品原价", example = "¥1300.00")
    String originalPrice
) implements BlockData {
}
