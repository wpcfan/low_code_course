package com.mooc.backend.rest.vm;

import io.swagger.v3.oas.annotations.media.Schema;

import java.util.List;

@Schema(description = "分页包装器，用于瀑布流分页模式，没有总页数")
public record SliceWrapper<T>(
        @Schema(description = "当前页码", example = "1")
        int page,
        @Schema(description = "每页大小", example = "10")
        int size,
        @Schema(description = "是否有下一页", example = "true")
        boolean hasNext,
        @Schema(description = "分页数据", example = "[{...}, {...}, {...}]")
        List<T> items
) {
}
