package com.mooc.backend.rest.vm;

import com.mooc.backend.entities.Category;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

@Schema(description = "创建或更新类目的视图模型")
public record CreateOrUpdateCategoryVM(
        @Schema(description = "类目名称", example = "手机数码")
        @NotBlank(message = "类目名称不能为空")
        @Size(min = 2, max = 100, message = "类目名称长度必须在 {min} - {max} 之间")
        String name,
        @Schema(description = "类目编码", example = "cat_mobile")
        @NotBlank(message = "类目编码不能为空")
        @Size(min = 2, max = 50, message = "类目编码长度必须在 {min} - {max} 之间")
        String code
) {
        public Category toCategory() {
                return Category.builder()
                        .name(name)
                        .code(code)
                        .build();
        }
}
