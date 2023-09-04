package com.mooc.backend.rest.app;

import com.mooc.backend.entities.Product;
import com.mooc.backend.entities.ProductData;
import com.mooc.backend.repositories.ProductRepository;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Tag(name = "商品查询", description = "客户端商品查询相关接口")
@RequestMapping("/api/v1/app/products")
@RestController
@RequiredArgsConstructor
public class ProductController {
    private final ProductRepository productRepository;

    @Operation(summary = "分页获取商品列表", description = "客户端瀑布流分页获取商品列表")
    @GetMapping("/by-category/{categoryId}")
    public Page<ProductData> findProductsByCategoryId(@PathVariable long categoryId, Pageable pageable) {
        return productRepository.findByCategoriesId(categoryId, pageable).map(ProductData::from);
    }
}
