package com.mooc.backend.rest.vm;

import com.mooc.backend.entities.PageConfig;
import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;

public record CreateOrUpdatePageLayoutVM(
        String title,
        PageConfig config,
        PageType pageType,
        Platform platform
) {
}
