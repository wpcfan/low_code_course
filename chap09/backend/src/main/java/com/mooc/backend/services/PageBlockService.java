package com.mooc.backend.services;

import com.mooc.backend.entities.PageBlock;
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

    public void movePageBlock(Long blockId, Long targetBlockId) {
        PageBlock pageBlock = getPageBlock(blockId);
        PageBlock targetPageBlock = getPageBlock(targetBlockId);
        if (!pageBlock.getPageLayout().equals(targetPageBlock.getPageLayout())) {
            throw new RuntimeException("页面区块不属于同一个页面布局");
        }
        final int targetSort = targetPageBlock.getSort();
        if (targetPageBlock.getSort() > pageBlock.getSort()) {
            pageBlock.getPageLayout().getPageBlocks().stream()
                    .filter(block -> block.getSort() > pageBlock.getSort() && block.getSort() <= targetPageBlock.getSort())
                    .forEach(block -> block.setSort(block.getSort() - 1));
        } else {
            pageBlock.getPageLayout().getPageBlocks().stream()
                    .filter(block -> block.getSort() < pageBlock.getSort() && block.getSort() >= targetPageBlock.getSort())
                    .forEach(block -> block.setSort(block.getSort() + 1));
        }
        pageBlock.setSort(targetSort);
        pageLayoutService.savePageLayout(pageBlock.getPageLayout());
    }
}
