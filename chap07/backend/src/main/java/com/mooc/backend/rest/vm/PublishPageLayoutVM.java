package com.mooc.backend.rest.vm;

import java.time.LocalDateTime;

public record PublishPageLayoutVM(
        LocalDateTime startTime,
        LocalDateTime endTime
) {
}
