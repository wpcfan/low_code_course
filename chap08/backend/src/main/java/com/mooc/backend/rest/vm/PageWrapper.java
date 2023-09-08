package com.mooc.backend.rest.vm;

import io.swagger.v3.oas.annotations.media.Schema;

import java.util.List;

@Schema(description = "分页包装器，用于表格分页模式，有总页数")
public record PageWrapper<T>(
        @Schema(description = "当前页码", example = "1")
        int page,
        @Schema(description = "每页大小", example = "10")
        int size,
        @Schema(description = "总页数", example = "10")
        int totalPages,
        @Schema(description = "总条数", example = "100")
        long totalSize,
        @Schema(description = "分页数据")
        List<T> items
) {
}
