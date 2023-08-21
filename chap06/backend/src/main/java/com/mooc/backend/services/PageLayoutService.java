package com.mooc.backend.services;

import com.mooc.backend.entities.PageBlock;
import com.mooc.backend.entities.PageLayout;
import com.mooc.backend.repositories.PageBlockRepository;
import com.mooc.backend.repositories.PageLayoutRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@RequiredArgsConstructor
@Service
public class PageLayoutService {
    private final PageLayoutRepository pageLayoutRepository;
    private final PageBlockRepository pageBlockRepository;
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

    public List<PageBlock> getPageBlocks() {
        return pageBlockRepository.findAll();
    }

    public PageBlock getPageBlock(Long id) {
        return pageBlockRepository.findById(id).orElseThrow();
    }

    public PageBlock savePageBlock(PageBlock pageBlock) {
        return pageBlockRepository.save(pageBlock);
    }
}
