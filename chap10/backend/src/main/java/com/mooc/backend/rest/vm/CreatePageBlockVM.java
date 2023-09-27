package com.mooc.backend.rest.vm;

import com.mooc.backend.entities.BlockConfig;
import com.mooc.backend.enumerations.BlockType;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.Valid;

import java.util.List;

@Schema(description = "创建或更新页面区块的视图模型")
public record CreatePageBlockVM(
        @Schema(description = "区块标题", example = "xx 牌牛奶推广区块")
        String title,
        @Schema(description = "区块配置")
        @Valid
        BlockConfig config,
        @Schema(description = "区块类型")
        BlockType type,
        @Schema(description = "区块数据")
        List<CreateOrUpdatePageBlockDataVM> data
        ) {
}
