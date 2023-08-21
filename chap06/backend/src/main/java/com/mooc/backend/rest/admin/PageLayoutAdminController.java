package com.mooc.backend.rest.admin;

import com.mooc.backend.entities.PageLayout;
import com.mooc.backend.enumerations.PageStatus;
import com.mooc.backend.rest.vm.CreateOrUpdatePageLayoutVM;
import com.mooc.backend.rest.vm.PageLayoutAdminVM;
import com.mooc.backend.services.PageLayoutService;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Tag(name = "页面布局管理", description = "页面布局管理相关接口")
@Validated
@RestController
@RequestMapping("/api/v1/admin/layouts")
@RequiredArgsConstructor
public class PageLayoutAdminController {
    private final PageLayoutService pageLayoutService;

    @GetMapping("/")
    public List<PageLayoutAdminVM> getPageLayouts() {
        return pageLayoutService.getPageLayouts()
                .stream()
                .map(PageLayoutAdminVM::toVM)
                .toList();
    }

    @GetMapping("/{id}")
    public PageLayoutAdminVM getPageLayout(@PathVariable Long id) {
        return PageLayoutAdminVM.toVM(pageLayoutService.getPageLayout(id));
    }

    @PostMapping("/")
    public PageLayoutAdminVM addPageLayout(@RequestBody @Valid CreateOrUpdatePageLayoutVM pageLayoutVM) {
        PageLayout pageLayout = new PageLayout();
        pageLayout.setTitle(pageLayoutVM.title());
        pageLayout.setConfig(pageLayoutVM.config());
        pageLayout.setStatus(PageStatus.DRAFT);
        pageLayout.setPageType(pageLayoutVM.pageType());
        pageLayout.setPlatform(pageLayoutVM.platform());
        return PageLayoutAdminVM.toVM(pageLayoutService.savePageLayout(pageLayout));
    }

    @PutMapping("/{id}")
    public PageLayoutAdminVM updatePageLayout(@PathVariable Long id, @RequestBody CreateOrUpdatePageLayoutVM pageLayoutVM) {
        PageLayout oldPageLayout = pageLayoutService.getPageLayout(id);
        oldPageLayout.setTitle(pageLayoutVM.title());
        oldPageLayout.setConfig(pageLayoutVM.config());
        oldPageLayout.setPageType(pageLayoutVM.pageType());
        oldPageLayout.setPlatform(pageLayoutVM.platform());
        return PageLayoutAdminVM.toVM(pageLayoutService.savePageLayout(oldPageLayout));
    }

    @DeleteMapping("/{id}")
    public void deletePageLayout(@PathVariable Long id) {
        pageLayoutService.deletePageLayout(id);
    }
}