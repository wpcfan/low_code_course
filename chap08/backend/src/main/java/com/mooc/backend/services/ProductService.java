package com.mooc.backend.services;

import com.mooc.backend.config.QiniuProperties;
import com.mooc.backend.entities.Product;
import com.mooc.backend.entities.ProductData;
import com.mooc.backend.entities.ProductImage;
import com.mooc.backend.repositories.CategoryRepository;
import com.mooc.backend.repositories.PageBlockDataRepository;
import com.mooc.backend.repositories.ProductRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@RequiredArgsConstructor
@Service
public class ProductService {
    private final ProductRepository productRepository;
    private final CategoryRepository categoryRepository;
    private final PageBlockDataRepository pageBlockDataRepository;
    private final QiniuService qiniuService;
    private final QiniuProperties properties;

    public Page<Product> findAll(Pageable pageable) {
        return productRepository.findAll(pageable);
    }

    public Product findById(Long id) {
        return productRepository.findById(id).orElseThrow();
    }

    @Transactional
    public Product save(Product product) {
        var result = productRepository.save(product);
        updatePageBlockDataWhenProductInfoChanges(result);
        return result;
    }

    private void updatePageBlockDataWhenProductInfoChanges(Product result) {
        pageBlockDataRepository.findAll()
                .stream()
                .filter(pageBlockData -> {
                    var isProductData = pageBlockData.getContent() instanceof ProductData;
                    if (isProductData) {
                        var productData = (ProductData) pageBlockData.getContent();
                        return productData.id().equals(result.getId());
                    }
                    return false;
                })
                .forEach(pageBlockData -> {
                    pageBlockData.setContent(ProductData.from(result));
                    pageBlockDataRepository.save(pageBlockData);
                });
    }

    @Transactional
    public void deleteById(Long id) {
        productRepository.deleteById(id);
    }

    @Transactional
    public Product addToCategory(Long productId, Long categoryId) {
        var product = productRepository.findById(productId).orElseThrow();
        var category = categoryRepository.findById(categoryId).orElseThrow();
        product.addCategory(category);
        return productRepository.save(product);
    }

    @Transactional
    public Product removeFromCategory(Long productId, Long categoryId) {
        var product = productRepository.findById(productId).orElseThrow();
        var category = categoryRepository.findById(categoryId).orElseThrow();
        product.removeCategory(category);
        return productRepository.save(product);
    }

    @Transactional
    public Product addProductImage(Long productId, String url) {
        var product = productRepository.findById(productId).orElseThrow();
        var productImage = new ProductImage();
        productImage.setUrl(url);
        product.addProductImage(productImage);
        var result = productRepository.save(product);
        updatePageBlockDataWhenProductInfoChanges(result);
        return result;
    }

    @Transactional
    public Product removeProductImage(Long productId, Long productImageId) {
        var product = productRepository.findById(productId).orElseThrow();
        var productImage = product.getProductImages().stream()
                .filter(image -> image.getId().equals(productImageId))
                .findFirst()
                .orElseThrow();
        product.removeProductImage(productImage);
        var result = productRepository.save(product);
        updatePageBlockDataWhenProductInfoChanges(result);
        return result;
    }

    @Transactional
    public Product uploadProductImage(Long productId, String key,  byte[] fileBytes) {
        Product product = productRepository.findById(productId).orElseThrow();
        var json = qiniuService.upload(fileBytes, key);
        ProductImage productImage = new ProductImage();
        productImage.setUrl(properties.getDomain() + "/" + json.key);
        product.addProductImage(productImage);
        var result = productRepository.save(product);
        updatePageBlockDataWhenProductInfoChanges(result);
        return result;
    }

}
