package com.mooc.backend.services;

import com.mooc.backend.entities.PageBlock;
import com.mooc.backend.entities.PageLayout;
import com.mooc.backend.repositories.PageBlockRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@RequiredArgsConstructor
@Service
public class PageBlockService {
    private final PageBlockRepository pageBlockRepository;
    private final PageLayoutService pageLayoutService;

    public PageBlock getPageBlock(Long id) {
        return pageBlockRepository.findById(id).orElseThrow();
    }

    @Transactional
    public PageBlock savePageBlock(PageBlock pageBlock) {
        return pageBlockRepository.save(pageBlock);
    }

    public void deletePageBlock(Long id) {
        pageBlockRepository.deleteById(id);
    }

    public void movePageBlock(PageLayout pageLayout, Long blockId, Long targetBlockId) {
        PageBlock pageBlock = pageLayout.getPageBlocks().stream()
                .filter(block -> block.getId().equals(blockId))
                .findFirst()
                .orElseThrow();
        PageBlock targetPageBlock = pageLayout.getPageBlocks().stream()
                .filter(block -> block.getId().equals(targetBlockId))
                .findFirst()
                .orElseThrow();

        final int targetSort = targetPageBlock.getSort();
        if (targetPageBlock.getSort() > pageBlock.getSort()) {
            pageLayout.getPageBlocks().stream()
                    .filter(block -> block.getSort() > pageBlock.getSort() && block.getSort() <= targetPageBlock.getSort())
                    .forEach(block -> block.setSort(block.getSort() - 1));
        } else {
            pageLayout.getPageBlocks().stream()
                    .filter(block -> block.getSort() < pageBlock.getSort() && block.getSort() >= targetPageBlock.getSort())
                    .forEach(block -> block.setSort(block.getSort() + 1));
        }
        pageBlock.setSort(targetSort);
        pageLayoutService.savePageLayout(pageLayout);
    }
}
