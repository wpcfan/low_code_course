package com.mooc.backend.json;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonDeserializer;

import java.io.IOException;
import java.math.BigDecimal;

public class PriceDeserializer extends JsonDeserializer<BigDecimal> {
    @Override
    public BigDecimal deserialize(JsonParser p, DeserializationContext ctxt) throws IOException {
        var value = p.getValueAsString();
        if (value == null) {
            return null;
        }
        var locale = java.util.Locale.CHINA;
        var numberFormat = java.text.NumberFormat.getCurrencyInstance(locale);
        try {
            return new BigDecimal(numberFormat.parse(value).toString());
        } catch (java.text.ParseException e) {
            throw new IOException(e);
        }
    }
}
