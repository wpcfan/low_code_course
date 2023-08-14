package com.mooc.backend.entities;

import lombok.*;

import java.io.Serial;
import java.io.Serializable;

@Data
public class PageConfig implements Serializable {
    @Serial
    private static final long serialVersionUID = 1L;

    private Double baselineScreenWidth;
}
