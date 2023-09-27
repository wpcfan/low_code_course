package com.mooc.backend.rest.vm;

import com.mooc.backend.entities.BlockData;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.Valid;

@Schema(description = "创建或更新页面区块数据的视图模型")
public record CreateOrUpdatePageBlockDataVM(

        @Schema(description = "区块数据")
        @Valid
        BlockData content
) {
}
