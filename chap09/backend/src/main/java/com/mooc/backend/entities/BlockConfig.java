package com.mooc.backend.entities;

import com.mooc.backend.constants.Constants;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.Pattern;
import lombok.*;

import java.io.Serial;
import java.io.Serializable;

@Builder
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "区块配置")
public class BlockConfig implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;
    @Schema(description = "区块的水平内边距", example = "12.0")
    @Min(value = 1, message = "必须大于等于 1")
    @Max(value = 48, message = "必须小于等于 48")
    private Double horizontalPadding;
    @Schema(description = "区块的垂直内边距", example = "12.0")
    @Min(value = 1, message = "必须大于等于 1")
    @Max(value = 48, message = "必须小于等于 48")
    private Double verticalPadding;
    @Schema(description = "区块的水平间距", example = "12.0")
    @Min(value = 1, message = "必须大于等于 1")
    @Max(value = 48, message = "必须小于等于 48")
    private Double horizontalSpacing;
    @Schema(description = "区块的垂直间距", example = "12.0")
    @Min(value = 1, message = "必须大于等于 1")
    @Max(value = 48, message = "必须小于等于 48")
    private Double verticalSpacing;
    @Schema(description = "区块的高度", example = "120")
    @Min(value = 1, message = "必须大于等于 1")
    @Max(value = 1000, message = "必须小于等于 1000")
    private Double blockHeight;
    @Schema(description = "区块的背景颜色", example = "#FFFFFF")
    @Pattern(regexp = Constants.HEX_COLOR_REGEX_WITH_HASH, message = "必须是合法的颜色值")
    private String backgroundColor;
    @Schema(description = "区块的边框颜色", example = "#FFFFFF")
    @Pattern(regexp = Constants.HEX_COLOR_REGEX_WITH_HASH, message = "必须是合法的颜色值")
    private String borderColor;
    @Schema(description = "区块的边框宽度", example = "1.0")
    @Min(value = 0, message = "必须大于等于 0")
    @Max(value = 48, message = "必须小于等于 48")
    private Double borderWidth;
}

