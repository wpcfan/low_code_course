package com.mooc.backend.examples;

import com.mooc.backend.entities.Product;
import org.springframework.data.domain.Example;
import org.springframework.data.domain.ExampleMatcher;

import java.util.function.Function;

public class SearchProductExample {
    public static final Function<String, Example<Product>> searchProductExample = keyword -> {
        ExampleMatcher matcher = ExampleMatcher.matchingAny()
                .withMatcher("name", ExampleMatcher.GenericPropertyMatchers.contains().ignoreCase())
                .withMatcher("description", ExampleMatcher.GenericPropertyMatchers.contains().ignoreCase())
                .withMatcher("sku", ExampleMatcher.GenericPropertyMatchers.contains().ignoreCase());
        Product product = new Product();
        product.setName(keyword);
        product.setDescription(keyword);
        product.setSku(keyword);
        return Example.of(product, matcher);
    };
}
