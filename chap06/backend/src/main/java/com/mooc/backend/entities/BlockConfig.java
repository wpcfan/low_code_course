package com.mooc.backend.entities;

import lombok.Data;

import java.io.Serial;
import java.io.Serializable;

@Data
public class BlockConfig implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;

    private Double horizontalPadding;

    private Double verticalPadding;

    private Double horizontalSpacing;

    private Double verticalSpacing;

    private Double blockWidth;

    private Double blockHeight;

    private String backgroundColor;

    private String borderColor;

    private Double borderWidth;
}

