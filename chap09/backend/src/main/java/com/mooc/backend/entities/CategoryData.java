package com.mooc.backend.entities;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import io.swagger.v3.oas.annotations.media.Schema;

import java.util.List;

@Schema(description = "分类区块数据")
@JsonDeserialize(as = CategoryData.class)
public record CategoryData(
    @Schema(description = "分类 ID", example = "1")
    Long id,
    @Schema(description = "分类名称", example = "手机")
    String name,
    @Schema(description = "分类代码", example = "phone")
    String code,
    @Schema(description = "子分类列表")
    List<CategoryData> children
) implements BlockData {
    public static CategoryData from(Category category) {
        return new CategoryData(
            category.getId(),
            category.getName(),
            category.getCode(),
            category.getChildren().stream()
                    .map(CategoryData::from).toList()
        );
    }
}
