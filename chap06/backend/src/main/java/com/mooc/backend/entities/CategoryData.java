package com.mooc.backend.entities;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "分类区块数据")
@JsonDeserialize(as = CategoryData.class)
public record CategoryData(
    @Schema(description = "分类 ID", example = "1")
    Long id,
    @Schema(description = "分类名称", example = "手机")
    String name,
    @Schema(description = "分类代码", example = "phone")
    String code
) implements BlockData {
}
