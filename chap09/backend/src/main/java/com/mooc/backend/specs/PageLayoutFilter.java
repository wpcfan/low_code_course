package com.mooc.backend.specs;

import com.mooc.backend.enumerations.PageStatus;
import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;

import java.time.LocalDateTime;

public record PageLayoutFilter (
        String title,
        PageType pageType,
        PageStatus status,
        Platform platform,
        LocalDateTime startTimeFrom,
        LocalDateTime startTimeTo,
        LocalDateTime endTimeFrom,
        LocalDateTime endTimeTo
) {
}
