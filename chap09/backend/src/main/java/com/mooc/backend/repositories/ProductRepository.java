package com.mooc.backend.repositories;

import com.mooc.backend.entities.Product;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface ProductRepository extends JpaRepository<Product, Long> {

    @Query("""
            select p
            from Product p
            where lower(p.name) like lower(concat('%', :keyword, '%'))
            or lower(p.description) like lower(concat('%', :keyword, '%'))
            or lower(p.sku) like lower(concat('%', :keyword, '%'))
            """)
    Page<Product> findByKeyword(String keyword, Pageable pageable);
    Slice<Product> findByCategoriesId(Long categoryId, Pageable pageable);
}
