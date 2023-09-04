package com.mooc.backend.rest.vm;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotNull;

@Schema(description = "创建或更新商品图片的视图模型")
public record CreateOrUpdateProductImageVM(
        @Schema(description = "图片 URL", example = "https://picsum.photos/200/300")
        @NotNull(message = "图片 URL 不能为空")
        String url
) {
}
