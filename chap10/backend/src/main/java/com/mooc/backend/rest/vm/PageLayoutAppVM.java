package com.mooc.backend.rest.vm;

import com.mooc.backend.entities.PageBlock;
import com.mooc.backend.entities.PageConfig;
import com.mooc.backend.entities.PageLayout;
import io.swagger.v3.oas.annotations.media.Schema;

import java.time.LocalDateTime;
import java.util.Set;

@Schema(description = "页面布局的视图模型 - APP")
public record PageLayoutAppVM(
        @Schema(description = "页面布局 ID", example = "1")
        Long id,
        @Schema(description = "页面配置")
        PageConfig config,
        @Schema(description = "页面开始时间", example = "2021-06-01T00:00:00")
        LocalDateTime startTime,
        @Schema(description = "页面结束时间", example = "2021-06-30T23:59:59")
        LocalDateTime endTime,
        @Schema(description = "页面区块列表")
        Set<PageBlock> blocks
) {
    public static PageLayoutAppVM toVM(PageLayout pageLayout) {
        return new PageLayoutAppVM(
                pageLayout.getId(),
                pageLayout.getConfig(),
                pageLayout.getStartTime(),
                pageLayout.getEndTime(),
                pageLayout.getPageBlocks()
        );
    }
}
