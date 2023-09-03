package com.mooc.backend.rest.admin;

import com.mooc.backend.entities.Product;
import com.mooc.backend.repositories.CategoryRepository;
import com.mooc.backend.repositories.ProductRepository;
import com.mooc.backend.rest.vm.CreateOrUpdateCategoryVM;
import com.mooc.backend.rest.vm.CreateOrUpdateProductVM;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

@Tag(name = "商品管理", description = "商品相关接口")
@Validated
@RestController
@RequestMapping("/api/v1/admin/products")
@RequiredArgsConstructor
public class ProductAdminController {

    private final ProductRepository productRepository;

    @Operation(summary = "分页获取商品列表")
    @GetMapping("")
    public Page<Product> getProducts(Pageable pageable) {
        return productRepository.findAll(pageable);
    }

    @Operation(summary = "根据 ID 获取商品")
    @GetMapping("/{id}")
    public Product getProduct(Long id) {
        return productRepository.findById(id).orElseThrow();
    }

    @Operation(summary = "添加商品")
    @PostMapping("")
    public Product addProduct(@RequestBody @Valid CreateOrUpdateProductVM createOrUpdateProductVM) {
        Product product = new Product();
        product.setSku(createOrUpdateProductVM.sku());
        product.setName(createOrUpdateProductVM.name());
        product.setDescription(createOrUpdateProductVM.description());
        product.setPrice(createOrUpdateProductVM.price());
        product.setOriginalPrice(createOrUpdateProductVM.originalPrice());
        return productRepository.save(product);
    }

    @Operation(summary = "更新商品")
    @PutMapping("/{id}")
    public Product updateProduct(@PathVariable Long id, @RequestBody @Valid CreateOrUpdateProductVM createOrUpdateProductVM) {
        Product product = productRepository.findById(id).orElseThrow();
        product.setSku(createOrUpdateProductVM.sku());
        product.setName(createOrUpdateProductVM.name());
        product.setDescription(createOrUpdateProductVM.description());
        product.setPrice(createOrUpdateProductVM.price());
        product.setOriginalPrice(createOrUpdateProductVM.originalPrice());
        return productRepository.save(product);
    }

    @Operation(summary = "删除商品")
    @DeleteMapping("/{id}")
    public void deleteProduct(@PathVariable Long id) {
        productRepository.deleteById(id);
    }

    @Operation(summary = "为商品添加类目")
    @PostMapping("/{id}/categories")
    public Product addCategory(
            @PathVariable Long id,
            @RequestBody CreateOrUpdateCategoryVM createOrUpdateCategoryVM
            ) {
        Product product = productRepository.findById(id).orElseThrow();
        product.addCategory(createOrUpdateCategoryVM.toCategory());
        return productRepository.save(product);
    }
}
