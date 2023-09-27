package com.mooc.backend.rest.vm;

import java.util.List;

public record PageWrapper<T>(
        int page,
        int size,
        int totalPages,
        long totalSize,
        List<T> items
) {
}
