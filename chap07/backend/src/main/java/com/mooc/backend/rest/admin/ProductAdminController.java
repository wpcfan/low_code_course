package com.mooc.backend.rest.admin;

import com.mooc.backend.config.QiniuProperties;
import com.mooc.backend.entities.Product;
import com.mooc.backend.entities.ProductImage;
import com.mooc.backend.repositories.CategoryRepository;
import com.mooc.backend.repositories.ProductImageRepository;
import com.mooc.backend.repositories.ProductRepository;
import com.mooc.backend.rest.vm.CreateOrUpdateProductImageVM;
import com.mooc.backend.rest.vm.CreateOrUpdateProductVM;
import com.mooc.backend.services.QiniuService;
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

    private final ProductRepository productRepository;
    private final CategoryRepository categoryRepository;
    private final ProductImageRepository productImageRepository;
    private final QiniuService qiniuService;
    private final QiniuProperties properties;

    @Operation(summary = "分页获取商品列表")
    @GetMapping("")
    public Page<Product> getProducts(Pageable pageable) {
        return productRepository.findAll(pageable);
    }

    @Operation(summary = "根据 ID 获取商品")
    @GetMapping("/{id}")
    public Product getProduct(@PathVariable Long id) {
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
    @PostMapping("/{id}/categories/{categoryId}")
    public Product addCategory(
            @PathVariable Long id,
            @PathVariable Long categoryId
            ) {
        Product product = productRepository.findById(id).orElseThrow();
        var category = categoryRepository.findById(categoryId).orElseThrow();
        product.addCategory(category);
        return productRepository.save(product);
    }

    @Operation(summary = "为商品删除类目")
    @DeleteMapping("/{id}/categories/{categoryId}")
    public void removeCategory(
            @PathVariable Long id,
            @PathVariable Long categoryId
            ) {
        Product product = productRepository.findById(id).orElseThrow();
        var category = product.getCategories().stream()
                .filter(c -> c.getId().equals(categoryId))
                .findFirst()
                .orElseThrow();
        product.removeCategory(category);
        productRepository.save(product);
    }

    @Operation(summary = "为商品添加图片")
    @PostMapping("/{id}/images")
    public Product addImage(
            @PathVariable Long id,
            @RequestBody @Valid CreateOrUpdateProductImageVM createOrUpdateProductImageVM
            ) {
        Product product = productRepository.findById(id).orElseThrow();
        ProductImage productImage = new ProductImage();
        productImage.setUrl(createOrUpdateProductImageVM.url());
        product.addProductImage(productImage);
        return productRepository.save(product);
    }

    @Operation(summary = "为商品删除图片")
    @DeleteMapping("/{id}/images/{imageId}")
    public void removeImage(
            @PathVariable Long id,
            @PathVariable Long imageId
            ) {
//        productImageRepository.deleteById(imageId);
        Product product = productRepository.findById(id).orElseThrow();
        var productImage = product.getProductImages().stream()
                .filter(c -> c.getId().equals(imageId))
                .findFirst()
                .orElseThrow();
        product.removeProductImage(productImage);
        productRepository.save(product);
    }

    @Operation(summary = "为商品上传单张图片")
    @PostMapping(value = "/{id}/image-file", consumes = {"multipart/form-data"})
    public Product addImageFile(
            @PathVariable Long id,
            @RequestParam("file") MultipartFile file
    ) {
        Product product = productRepository.findById(id).orElseThrow();
        var key = FileUtils.buildFileKey(file.getOriginalFilename());
        try {
            var json = qiniuService.upload(file.getBytes(), key);
            ProductImage productImage = new ProductImage();
            productImage.setUrl(properties.getDomain() + "/" + json.key);
            product.addProductImage(productImage);
            return productRepository.save(product);
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
