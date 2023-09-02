package com.mooc.backend.entities;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.util.LinkedHashSet;
import java.util.Set;

@Builder
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "mooc_products")
public class Product {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String sku;

    private String name;

    private String description;

    private BigDecimal price;

    private BigDecimal originalPrice;

    @OneToMany(mappedBy = "product", orphanRemoval = true)
    private Set<ProductImage> productImages = new LinkedHashSet<>();

    @ManyToMany
    @JoinTable(name = "mooc_products_categories",
            joinColumns = @JoinColumn(name = "product_id"),
            inverseJoinColumns = @JoinColumn(name = "categories_id"))
    private Set<Category> categories = new LinkedHashSet<>();

}
