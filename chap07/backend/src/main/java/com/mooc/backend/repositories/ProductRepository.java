package com.mooc.backend.repositories;

import com.mooc.backend.entities.Product;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ProductRepository extends JpaRepository<Product, Long> {
    Slice<Product> findByCategoriesId(Long categoryId, Pageable pageable);
}
