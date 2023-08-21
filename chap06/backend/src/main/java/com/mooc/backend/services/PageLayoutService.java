package com.mooc.backend.services;

import com.mooc.backend.entities.PageLayout;
import com.mooc.backend.repositories.PageLayoutRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

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
}
