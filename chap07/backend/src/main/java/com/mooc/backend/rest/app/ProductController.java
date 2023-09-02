package com.mooc.backend.rest.app;

import com.mooc.backend.entities.Product;
import com.mooc.backend.entities.ProductData;
import com.mooc.backend.repositories.ProductRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RequestMapping("/api/v1/app/products")
@RestController
@RequiredArgsConstructor
public class ProductController {
    private final ProductRepository productRepository;

    @GetMapping("/by-category/{categoryId}")
    public Page<Product> findProductsByCategoryId(@PathVariable long categoryId, Pageable pageable) {
        return productRepository.findByCategoriesId(categoryId, pageable);
    }
}
