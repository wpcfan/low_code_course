package com.mooc.backend.rest.app;

import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;
import com.mooc.backend.rest.vm.PageLayoutDetailVM;
import com.mooc.backend.services.PageLayoutService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RequestMapping("/api/v1/app/layouts")
@RestController
@RequiredArgsConstructor
public class PageLayoutController {
    final PageLayoutService pageLayoutService;

    @GetMapping("/")
    public PageLayoutDetailVM getPageLayout(
            @RequestParam Platform platform,
            @RequestParam PageType pageType
            ) {
        return PageLayoutDetailVM.toVM(pageLayoutService.findByPlatformAndPageType(platform, pageType));
    }
}
