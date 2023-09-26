package com.mooc.backend.rest.admin;

import com.mooc.backend.services.ValidationService;
import com.mooc.backend.specs.PageLayoutFilter;
import com.mooc.backend.specs.PageLayoutSpec;
import org.springdoc.core.annotations.ParameterObject;
import org.springframework.data.domain.Pageable;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.mooc.backend.entities.PageLayout;
import com.mooc.backend.enumerations.PageStatus;
import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;
import com.mooc.backend.rest.vm.CreateOrUpdatePageLayoutVM;
import com.mooc.backend.rest.vm.PageLayoutAdminVM;
import com.mooc.backend.rest.vm.PageLayoutDetailVM;
import com.mooc.backend.rest.vm.PageWrapper;
import com.mooc.backend.rest.vm.PublishPageLayoutVM;
import com.mooc.backend.services.PageLayoutService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

import java.time.LocalDate;
import java.time.LocalTime;

@Tag(name = "页面布局管理", description = "页面布局管理相关接口")
@Validated
@RestController
@RequestMapping("/api/v1/admin/layouts")
@RequiredArgsConstructor
public class PageLayoutAdminController {
    private final PageLayoutService pageLayoutService;
    private final ValidationService validationService;

    @Operation(summary = "获取页面布局列表")
    @GetMapping("")
    public PageWrapper<PageLayoutAdminVM> getPageLayouts(
            @RequestParam(required = false) String title,
            @RequestParam(required = false) Platform platform,
            @RequestParam(required = false) PageStatus status,
            @RequestParam(required = false) PageType pageType,
            @DateTimeFormat(pattern = "yyyyMMdd") @RequestParam(required = false) LocalDate startTimeFrom,
            @DateTimeFormat(pattern = "yyyyMMdd") @RequestParam(required = false) LocalDate startTimeTo,
            @DateTimeFormat(pattern = "yyyyMMdd") @RequestParam(required = false) LocalDate endTimeFrom,
            @DateTimeFormat(pattern = "yyyyMMdd") @RequestParam(required = false) LocalDate endTimeTo,
            @ParameterObject Pageable pageable) {
        PageLayoutFilter filter = new PageLayoutFilter(
                title,
                pageType,
                status,
                platform,
                startTimeFrom != null ? startTimeFrom.atStartOfDay() : null,
                startTimeTo != null ? startTimeTo.atTime(LocalTime.MAX) : null,
                endTimeFrom != null ? endTimeFrom.atStartOfDay() : null,
                endTimeTo != null ? endTimeTo.atTime(LocalTime.MAX) : null);
        var spec = new PageLayoutSpec(filter);
        var result = pageLayoutService.getPageLayouts(spec, pageable)
                .map(PageLayoutAdminVM::toVM);
        return new PageWrapper<>(
                result.getNumber(),
                result.getSize(),
                result.getTotalPages(),
                result.getTotalElements(),
                result.getContent());
    }

    @Operation(summary = "根据 ID 获取页面布局")
    @GetMapping("/{id}")
    public PageLayoutDetailVM getPageLayout(@PathVariable Long id) {
        return PageLayoutDetailVM.toVM(pageLayoutService.getPageLayout(id));
    }

    @Operation(summary = "添加页面布局")
    @PostMapping("")
    public PageLayoutAdminVM addPageLayout(@RequestBody @Valid CreateOrUpdatePageLayoutVM pageLayoutVM) {
        PageLayout pageLayout = new PageLayout();
        pageLayout.setTitle(pageLayoutVM.title());
        pageLayout.setConfig(pageLayoutVM.config());
        pageLayout.setStatus(PageStatus.DRAFT);
        pageLayout.setPageType(pageLayoutVM.pageType());
        pageLayout.setPlatform(pageLayoutVM.platform());
        return PageLayoutAdminVM.toVM(pageLayoutService.savePageLayout(pageLayout));
    }

    @Operation(summary = "更新页面布局")
    @PutMapping("/{id}")
    public PageLayoutAdminVM updatePageLayout(@PathVariable Long id,
            @RequestBody @Valid CreateOrUpdatePageLayoutVM pageLayoutVM) {
        validationService.checkPageStatusIsDraft(id);
        PageLayout oldPageLayout = pageLayoutService.getPageLayout(id);
        oldPageLayout.setTitle(pageLayoutVM.title());
        oldPageLayout.setConfig(pageLayoutVM.config());
        oldPageLayout.setPageType(pageLayoutVM.pageType());
        oldPageLayout.setPlatform(pageLayoutVM.platform());
        return PageLayoutAdminVM.toVM(pageLayoutService.savePageLayout(oldPageLayout));
    }

    @Operation(summary = "发布页面布局")
    @PatchMapping("/{id}/status/publish")
    public PageLayoutAdminVM publishPageLayout(
            @PathVariable Long id,
            @RequestBody @Valid PublishPageLayoutVM publishPageLayoutVM) {
        PageLayout pageLayout = pageLayoutService.getPageLayout(id);
        pageLayout.setStatus(PageStatus.PUBLISHED);
        pageLayout.setStartTime(publishPageLayoutVM.startTime());
        pageLayout.setEndTime(publishPageLayoutVM.endTime());
        return PageLayoutAdminVM.toVM(pageLayoutService.savePageLayout(pageLayout));
    }

    @Operation(summary = "撤回页面布局")
    @PatchMapping("/{id}/status/draft")
    public PageLayoutAdminVM draftPageLayout(@PathVariable Long id) {
        PageLayout pageLayout = pageLayoutService.getPageLayout(id);
        pageLayout.setStatus(PageStatus.DRAFT);
        pageLayout.setStartTime(null);
        pageLayout.setEndTime(null);
        return PageLayoutAdminVM.toVM(pageLayoutService.savePageLayout(pageLayout));
    }

    @Operation(summary = "删除页面布局")
    @DeleteMapping("/{id}")
    public void deletePageLayout(@PathVariable Long id) {
        validationService.checkPageStatusIsDraft(id);
        pageLayoutService.deletePageLayout(id);
    }

}
