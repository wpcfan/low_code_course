package com.mooc.backend.rest.vm;

import com.mooc.backend.entities.PageConfig;
import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

@Schema(description = "创建或更新页面布局的视图模型")
public record CreateOrUpdatePageLayoutVM(
        @Schema(description = "页面标题", example = "首页618活动")
        @NotBlank(message = "不能为空")
        @Size(max = 100, message = "长度不能超过100个字符")
        String title,
        @Schema(description = "页面配置")
        @Valid
        PageConfig config,
        @Schema(description = "页面类型", example = "Home")
        PageType pageType,
        @Schema(description = "页面平台", example = "APP")
        Platform platform
) {
}
