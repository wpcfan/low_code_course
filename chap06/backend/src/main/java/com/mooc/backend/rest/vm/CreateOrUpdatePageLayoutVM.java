package com.mooc.backend.rest.vm;

import com.mooc.backend.entities.PageConfig;
import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record CreateOrUpdatePageLayoutVM(
        @Schema(description = "页面标题")
        @NotBlank(message = "不能为空")
        @Size(max = 100, message = "长度不能超过100个字符")
        String title,
        PageConfig config,
        PageType pageType,
        Platform platform
) {
}
