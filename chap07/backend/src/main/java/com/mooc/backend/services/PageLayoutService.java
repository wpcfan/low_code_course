package com.mooc.backend.services;

import com.mooc.backend.entities.PageLayout;
import com.mooc.backend.enumerations.PageStatus;
import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;
import com.mooc.backend.repositories.PageLayoutRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@RequiredArgsConstructor
@Service
public class PageLayoutService {
    private final PageLayoutRepository pageLayoutRepository;

    public PageLayout getPageLayout(Long id) {
        return pageLayoutRepository.findById(id).orElseThrow();
    }


    public List<PageLayout> getPageLayouts() {
        return pageLayoutRepository.findAll();
    }

    public PageLayout savePageLayout(PageLayout pageLayout) {
        return pageLayoutRepository.save(pageLayout);
    }

    public void deletePageLayout(Long id) {
        pageLayoutRepository.deleteById(id);
    }

    public PageLayout findByPlatformAndPageType(Platform platform, PageType pageType) {
        // select from mooc_page_layouts where platform = platform and page_type = pageType
        // 返回的是一个列表，有可能是空的，也有可能是 1 个元素，也有可能多余一个
        // 如果是空的，我们需要提供一个兜底的布局
        // 如果是 1 个，直接返回
        // 如果多余 1 个，需要返回第一个
        LocalDateTime now = LocalDateTime.now();
        List<PageLayout> pageLayoutList = pageLayoutRepository
                .findByPlatformAndPageTypeAndStatusAndStartTimeLessThanAndEndTimeGreaterThan(
                        platform,
                        pageType,
                        PageStatus.PUBLISHED,
                        now,
                        now
                );
        if (pageLayoutList.isEmpty()) {
            // 如果是空的，我们需要提供一个兜底的布局
            return PageLayout.builder()
                    .build();
        }
        return pageLayoutList.stream().findFirst().orElseThrow();
    }
}
