package com.mooc.backend.rest.vm;

import com.mooc.backend.entities.BlockConfig;
import com.mooc.backend.enumerations.BlockType;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;

@Schema(description = "创建或更新页面区块的视图模型")
public record CreateOrUpdatePageBlockVM(
        @Schema(description = "区块类型", example = "Banner")
        BlockType type,
        @Schema(description = "区块配置")
        @Valid
        BlockConfig config,
        @Schema(description = "区块排序", example = "1")
        @Min(value = 1, message = "必须大于等于 1")
        @Max(value = 100, message = "必须小于等于 100")
        Integer sort) {
}
