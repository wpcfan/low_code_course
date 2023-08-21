package com.mooc.backend.rest.admin;

import com.mooc.backend.entities.PageLayout;
import com.mooc.backend.services.PageLayoutService;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Tag(name = "页面布局管理", description = "页面布局管理相关接口")
@RestController
@RequestMapping("/api/v1/admin/layouts")
@RequiredArgsConstructor
public class PageLayoutController {
    private final PageLayoutService pageLayoutService;

    @GetMapping("/")
    public List<PageLayout> getPageLayouts() {
        return pageLayoutService.getPageLayouts();
    }

    @GetMapping("/{id}")
    public PageLayout getPageLayout(@PathVariable Long id) {
        return pageLayoutService.getPageLayout(id);
    }

    @PostMapping("/")
    public PageLayout addPageLayout(@RequestBody PageLayout pageLayout) {
        return pageLayoutService.savePageLayout(pageLayout);
    }

    @PutMapping("/{id}")
    public PageLayout updatePageLayout(@PathVariable Long id, @RequestBody PageLayout pageLayout) {
        pageLayout.setId(id);
        return pageLayoutService.savePageLayout(pageLayout);
    }

    @DeleteMapping("/{id}")
    public void deletePageLayout(@PathVariable Long id) {
        pageLayoutService.deletePageLayout(id);
    }
}
