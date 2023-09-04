package com.mooc.backend.json;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonDeserializer;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.mooc.backend.entities.BlockData;
import com.mooc.backend.entities.CategoryData;
import com.mooc.backend.entities.ImageData;
import com.mooc.backend.entities.ProductData;

import java.io.IOException;

public class BlockDataDeserializer extends JsonDeserializer<BlockData> {

    @Override
    public BlockData deserialize(JsonParser p, DeserializationContext ctxt) throws IOException {
        ObjectMapper mapper = (ObjectMapper) p.getCodec();
        ObjectNode root = mapper.readTree(p);
        if (root.has("price")) {
            return mapper.readValue(root.toString(), ProductData.class);
        }
        if (root.has("image")) {
            return mapper.readValue(root.toString(), ImageData.class);
        }
        if (root.has("code")) {
            return mapper.readValue(root.toString(), CategoryData.class);
        }
        return null;
    }
}
