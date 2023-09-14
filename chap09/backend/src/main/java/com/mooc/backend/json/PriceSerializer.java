package com.mooc.backend.json;

import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.JsonSerializer;
import com.fasterxml.jackson.databind.SerializerProvider;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.Locale;

public class PriceSerializer extends JsonSerializer<BigDecimal> {

    @Override
    public void serialize(BigDecimal value, JsonGenerator gen, SerializerProvider serializers) throws IOException {
        var rounded = value.setScale(2, RoundingMode.HALF_UP);
        var locale = Locale.CHINA;
        var numberFormat = java.text.NumberFormat.getCurrencyInstance(locale);
        gen.writeString(numberFormat.format(rounded));
    }
}
