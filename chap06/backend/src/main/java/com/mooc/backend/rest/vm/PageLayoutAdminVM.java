package com.mooc.backend.rest.vm;

import com.mooc.backend.entities.PageConfig;
import com.mooc.backend.entities.PageLayout;
import com.mooc.backend.enumerations.PageStatus;
import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;

import java.time.LocalDateTime;

public record PageLayoutAdminVM(
        Long id,
        String title,
        PageConfig config,
        LocalDateTime startTime,
        LocalDateTime endTime,
        PageStatus status,
        PageType pageType,
        Platform platform
) {
    public static PageLayoutAdminVM toVM(PageLayout pageLayout) {
        return new PageLayoutAdminVM(
                pageLayout.getId(),
                pageLayout.getTitle(),
                pageLayout.getConfig(),
                pageLayout.getStartTime(),
                pageLayout.getEndTime(),
                pageLayout.getStatus(),
                pageLayout.getPageType(),
                pageLayout.getPlatform()
        );
    }
}
