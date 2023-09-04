package com.mooc.backend.rest.app;

import com.mooc.backend.entities.ProductData;
import com.mooc.backend.repositories.ProductRepository;
import com.mooc.backend.rest.vm.PageWrapper;
import com.mooc.backend.rest.vm.SliceWrapper;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Slice;
import org.springframework.data.domain.Sort;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Tag(name = "商品查询", description = "客户端商品查询相关接口")
@RequestMapping("/api/v1/app/products")
@RestController
@RequiredArgsConstructor
public class ProductController {
    private final ProductRepository productRepository;

    @Operation(summary = "分页获取商品列表", description = "客户端瀑布流分页获取商品列表")
    @GetMapping("/by-category/{categoryId}")
    public SliceWrapper<ProductData> findProductsByCategoryId(
            @PathVariable long categoryId,
            @RequestParam int page,
            @RequestParam int pageSize,
            @RequestParam(required = false, name = "sort") List<String> strSort
            ) {
        Sort sort = strSort.stream()
                .map(str -> {
                    String[] arr = str.split(",");
                    if (arr.length == 1) {
                        return Sort.by(arr[0]);
                    } else {
                        return Sort.by(arr[0]).descending();
                    }
                })
                .reduce(Sort::and)
                .orElse(Sort.unsorted());
        Pageable pageable = PageRequest.of(page, pageSize, sort);
        var result = productRepository.findByCategoriesId(categoryId, pageable).map(ProductData::from);
        return new SliceWrapper<>(result.getNumber(), result.getSize(), result.getContent());
    }
}
