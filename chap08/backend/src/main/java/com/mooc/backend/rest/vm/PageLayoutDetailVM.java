package com.mooc.backend.rest.vm;

import com.mooc.backend.entities.PageBlock;
import com.mooc.backend.entities.PageConfig;
import com.mooc.backend.entities.PageLayout;
import com.mooc.backend.enumerations.PageStatus;
import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;
import io.swagger.v3.oas.annotations.media.Schema;

import java.time.LocalDateTime;
import java.util.Set;

public record PageLayoutDetailVM(
        @Schema(description = "页面布局 ID", example = "1")
        Long id,
        @Schema(description = "页面标题", example = "首页618活动")
        String title,
        @Schema(description = "页面配置")
        PageConfig config,
        @Schema(description = "页面开始时间", example = "2021-06-01T00:00:00")
        LocalDateTime startTime,
        @Schema(description = "页面结束时间", example = "2021-06-30T23:59:59")
        LocalDateTime endTime,
        @Schema(description = "页面状态", example = "DRAFT")
        PageStatus status,
        @Schema(description = "页面类型", example = "Home")
        PageType pageType,
        @Schema(description = "页面平台", example = "APP")
        Platform platform,
        @Schema(description = "页面区块列表", example = "[{...},{...},{...}]")
        Set<PageBlock> blocks
) {
    public static PageLayoutDetailVM toVM(PageLayout pageLayout) {
        return new PageLayoutDetailVM(
                pageLayout.getId(),
                pageLayout.getTitle(),
                pageLayout.getConfig(),
                pageLayout.getStartTime(),
                pageLayout.getEndTime(),
                pageLayout.getStatus(),
                pageLayout.getPageType(),
                pageLayout.getPlatform(),
                pageLayout.getPageBlocks()
        );
    }
}
