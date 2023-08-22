package com.mooc.backend.entities;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import io.swagger.v3.oas.annotations.media.Schema;

@Schema(description = "图片区块数据")
@JsonDeserialize(as = ImageData.class)
public record ImageData(
    @Schema(description = "图片地址", example = "https://picsum.photos/200/300")
    String image,
    @Schema(description = "图片链接")
    ImageLink link,
    @Schema(description = "图片标题", example = "图片标题")
    String title
) implements BlockData {
}
