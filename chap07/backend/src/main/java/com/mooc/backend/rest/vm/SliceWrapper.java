package com.mooc.backend.rest.vm;

import java.util.List;

public record SliceWrapper<T>(
        int page,
        int size,
        List<T> items
) {
}
