package com.mooc.backend.rest.app;

import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;
import com.mooc.backend.rest.vm.PageLayoutAppVM;
import com.mooc.backend.services.PageLayoutService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@Tag(name = "页面布局查询", description = "客户端页面布局相关接口")
@RequestMapping("/api/v1/app/layouts")
@RestController
@RequiredArgsConstructor
public class PageLayoutController {
    final PageLayoutService pageLayoutService;

    @Operation(summary = "获取页面布局详情", description = "客户端获取页面布局详情")
    @GetMapping("")
    public PageLayoutAppVM getPageLayout(
            @RequestParam Platform platform,
            @RequestParam PageType pageType
            ) {
        return PageLayoutAppVM.toVM(pageLayoutService.findByPlatformAndPageType(platform, pageType));
    }
}
