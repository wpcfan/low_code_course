package com.mooc.backend.entities;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.mooc.backend.json.BlockDataDeserializer;

@JsonDeserialize(using = BlockDataDeserializer.class)
public interface BlockData {
}
