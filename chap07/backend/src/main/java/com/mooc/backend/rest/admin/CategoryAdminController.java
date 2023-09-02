package com.mooc.backend.rest.admin;

import com.mooc.backend.entities.Category;
import com.mooc.backend.repositories.CategoryRepository;
import com.mooc.backend.rest.vm.CreateOrUpdateCategoryVM;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

@Tag(name = "类目管理", description = "类目相关接口")
@Validated
@RestController
@RequestMapping("/api/v1/admin/categories")
@RequiredArgsConstructor
public class CategoryAdminController {

    private final CategoryRepository categoryRepository;

    @Operation(summary = "添加类目")
    @PostMapping("")
    public Category addCategory(@RequestBody @Valid CreateOrUpdateCategoryVM createOrUpdateCategoryVM) {
        Category category = new Category();
        category.setName(createOrUpdateCategoryVM.name());
        category.setCode(createOrUpdateCategoryVM.code());
        return categoryRepository.save(category);
    }

    @Operation(summary = "更新类目")
    @PutMapping("/{id}")
    public Category updateCategory(@PathVariable Long id, @RequestBody @Valid CreateOrUpdateCategoryVM createOrUpdateCategoryVM) {
        Category category = categoryRepository.findById(id).orElseThrow();
        category.setName(createOrUpdateCategoryVM.name());
        category.setCode(createOrUpdateCategoryVM.code());
        return categoryRepository.save(category);
    }

    @Operation(summary = "删除类目")
    @DeleteMapping("/{id}")
    public void deleteCategory(@PathVariable Long id) {
        categoryRepository.deleteById(id);
    }

    @Operation(summary = "获取类目列表")
    @GetMapping("")
    public Iterable<Category> getCategories() {
        return categoryRepository.findAll();
    }

    @Operation(summary = "根据 ID 获取类目")
    @GetMapping("/{id}")
    public Category getCategory(@PathVariable Long id) {
        return categoryRepository.findById(id).orElseThrow();
    }
}
