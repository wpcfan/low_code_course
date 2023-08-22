package com.mooc.backend.entities;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.mooc.backend.json.BlockDataDeserializer;
import io.swagger.v3.oas.annotations.media.Schema;

@Schema(
        description = "区块数据，包含图片、分类、商品等",
        subTypes = {ImageData.class, CategoryData.class, ProductData.class},
        oneOf = {ImageData.class, CategoryData.class, ProductData.class}
)
@JsonDeserialize(using = BlockDataDeserializer.class)
public interface BlockData {
}
