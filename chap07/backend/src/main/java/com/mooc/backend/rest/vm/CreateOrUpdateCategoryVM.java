package com.mooc.backend.rest.vm;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record CreateOrUpdateCategoryVM(
        @NotBlank(message = "类目名称不能为空")
        @Size(min = 2, max = 100, message = "类目名称长度必须在 {min} - {max} 之间")
        String name,
        @NotBlank(message = "类目编码不能为空")
        @Size(min = 2, max = 50, message = "类目编码长度必须在 {min} - {max} 之间")
        String code
) {
}
