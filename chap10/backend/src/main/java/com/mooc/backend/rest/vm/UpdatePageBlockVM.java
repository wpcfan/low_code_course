package com.mooc.backend.rest.vm;

import com.mooc.backend.entities.BlockConfig;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.Valid;

public record UpdatePageBlockVM(
        @Schema(description = "区块标题", example = "xx 牌牛奶推广区块")
        String title,
        @Schema(description = "区块配置")
        @Valid
        BlockConfig config) {
}
