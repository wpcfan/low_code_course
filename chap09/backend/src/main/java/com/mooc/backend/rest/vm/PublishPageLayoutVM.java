package com.mooc.backend.rest.vm;

import com.mooc.backend.validators.ValidateDateRange;
import io.swagger.v3.oas.annotations.media.Schema;

import java.time.LocalDateTime;

@ValidateDateRange({"startTime", "endTime"})
@Schema(description = "发布页面布局的视图模型")
public record PublishPageLayoutVM(
        @Schema(description = "页面布局生效时间", example = "2021-06-01T00:00:00")
        LocalDateTime startTime,
        @Schema(description = "页面布局失效时间", example = "2099-06-30T23:59:59")
        LocalDateTime endTime
) {
}
