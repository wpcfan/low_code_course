package com.mooc.backend.rest.admin;

import com.mooc.backend.entities.Product;
import com.mooc.backend.rest.vm.CreateOrUpdateProductImageVM;
import com.mooc.backend.rest.vm.CreateOrUpdateProductVM;
import com.mooc.backend.services.ProductService;
import com.mooc.backend.utils.FileUtils;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.stream.Stream;

@Tag(name = "商品管理", description = "商品相关接口")
@Validated
@RestController
@RequestMapping("/api/v1/admin/products")
@RequiredArgsConstructor
public class ProductAdminController {

    private final ProductService productService;

    @Operation(summary = "分页获取商品列表")
    @GetMapping("")
    public Page<Product> getProducts(Pageable pageable) {
        return productService.findAll(pageable);
    }

    @Operation(summary = "根据 ID 获取商品")
    @GetMapping("/{id}")
    public Product getProduct(@PathVariable Long id) {
        return productService.findById(id);
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
        return productService.save(product);
    }

    @Operation(summary = "更新商品")
    @PutMapping("/{id}")
    public Product updateProduct(@PathVariable Long id, @RequestBody @Valid CreateOrUpdateProductVM createOrUpdateProductVM) {
        Product product = productService.findById(id);
        product.setSku(createOrUpdateProductVM.sku());
        product.setName(createOrUpdateProductVM.name());
        product.setDescription(createOrUpdateProductVM.description());
        product.setPrice(createOrUpdateProductVM.price());
        product.setOriginalPrice(createOrUpdateProductVM.originalPrice());
        return productService.save(product);
    }

    @Operation(summary = "删除商品")
    @DeleteMapping("/{id}")
    public void deleteProduct(@PathVariable Long id) {
        productService.deleteById(id);
    }

    @Operation(summary = "为商品添加类目")
    @PostMapping("/{id}/categories/{categoryId}")
    public Product addCategory(
            @PathVariable Long id,
            @PathVariable Long categoryId
            ) {
        return productService.addToCategory(id, categoryId);
    }

    @Operation(summary = "为商品删除类目")
    @DeleteMapping("/{id}/categories/{categoryId}")
    public void removeCategory(
            @PathVariable Long id,
            @PathVariable Long categoryId
            ) {
        productService.removeFromCategory(id, categoryId);
    }

    @Operation(summary = "为商品添加图片")
    @PostMapping("/{id}/images")
    public Product addImage(
            @PathVariable Long id,
            @RequestBody @Valid CreateOrUpdateProductImageVM createOrUpdateProductImageVM
            ) {
        return productService.addProductImage(id, createOrUpdateProductImageVM.url());
    }

    @Operation(summary = "为商品删除图片")
    @DeleteMapping("/{id}/images/{imageId}")
    public void removeImage(
            @PathVariable Long id,
            @PathVariable Long imageId
            ) {
        productService.removeProductImage(id, imageId);
    }

    @Operation(summary = "为商品上传单张图片")
    @PostMapping(value = "/{id}/image-file", consumes = {"multipart/form-data"})
    public Product addImageFile(
            @PathVariable Long id,
            @RequestParam("file") MultipartFile file
    ) {
        var key = FileUtils.buildFileKey(file.getOriginalFilename());
        try {
            var bytes = file.getBytes();
            return productService.uploadProductImage(id, key, bytes);
        } catch (IOException e) {
            throw new RuntimeException("文件上传失败");
        }
    }

    @Operation(summary = "为商品上传多张图片")
    @PostMapping(value = "/{id}/image-files", consumes = {"multipart/form-data"})
    public Product addImageFiles(
            @PathVariable Long id,
            @RequestPart("files") MultipartFile[] files
    ) {
        return Stream.of(files)
                .map(file -> addImageFile(id, file))
                .reduce((a, b) -> b)
                .orElseThrow();
    }

}
