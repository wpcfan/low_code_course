package com.mooc.backend.entities;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.proxy.HibernateProxy;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.LinkedHashSet;
import java.util.Objects;
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
    @Column(unique = true, nullable = false, length = 50)
    private String sku;
    @Column(nullable = false)
    private String name;

    private String description;

    @Column(nullable = false, precision = 10, scale = 2)
    private BigDecimal price;
    @Column(nullable = false, precision = 10, scale = 2)
    private BigDecimal originalPrice;

    @OneToMany(mappedBy = "product", orphanRemoval = true, cascade = CascadeType.ALL)
    private Set<ProductImage> productImages = new LinkedHashSet<>();

    @ManyToMany(cascade = {CascadeType.PERSIST, CascadeType.MERGE})
    @JoinTable(name = "mooc_products_categories",
            joinColumns = @JoinColumn(name = "product_id"),
            inverseJoinColumns = @JoinColumn(name = "category_id"))
    private Set<Category> categories = new LinkedHashSet<>();

    public void addProductImage(ProductImage productImage) {
        productImages.add(productImage);
        productImage.setProduct(this);
    }

    public void removeProductImage(ProductImage productImage) {
        productImages.remove(productImage);
        productImage.setProduct(null);
    }

    public void addCategory(Category category) {
        categories.add(category);
    }

    public void removeCategory(Category category) {
        categories.remove(category);
    }

    @PrePersist
    @PreUpdate
    public void pricePrecisionConvert() {
        if (price != null) {
            price = price.setScale(2, RoundingMode.HALF_UP);
        }
        if (originalPrice != null) {
            originalPrice = originalPrice.setScale(2, RoundingMode.HALF_UP);
        }
    }

    @Override
    public final boolean equals(Object o) {
        if (this == o) return true;
        if (o == null) return false;
        Class<?> oEffectiveClass = o instanceof HibernateProxy ? ((HibernateProxy) o).getHibernateLazyInitializer().getPersistentClass() : o.getClass();
        Class<?> thisEffectiveClass = this instanceof HibernateProxy ? ((HibernateProxy) this).getHibernateLazyInitializer().getPersistentClass() : this.getClass();
        if (thisEffectiveClass != oEffectiveClass) return false;
        Product product = (Product) o;
        return getId() != null && Objects.equals(getId(), product.getId());
    }

    @Override
    public final int hashCode() {
        return this instanceof HibernateProxy ? ((HibernateProxy) this).getHibernateLazyInitializer().getPersistentClass().hashCode() : getClass().hashCode();
    }
}
