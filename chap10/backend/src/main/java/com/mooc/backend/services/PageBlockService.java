package com.mooc.backend.services;

import com.mooc.backend.entities.PageBlock;
import com.mooc.backend.entities.PageBlockData;
import com.mooc.backend.entities.PageLayout;
import com.mooc.backend.enumerations.BlockType;
import com.mooc.backend.repositories.PageBlockRepository;
import com.mooc.backend.rest.vm.CreatePageBlockVM;
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

    public void deletePageBlock(PageLayout pageLayout, Long id) {
        PageBlock pageBlock = pageLayout.getPageBlocks().stream()
                .filter(block -> block.getId().equals(id))
                .findFirst()
                .orElseThrow();
        final int sort = pageBlock.getSort();
        pageLayout.removePageBlock(pageBlock);
        pageLayout.getPageBlocks().stream()
                        .filter(block -> block.getSort() > sort)
                        .forEach(block -> block.setSort(block.getSort() - 1));
        pageLayoutService.savePageLayout(pageLayout);
    }

    @Transactional
    public void movePageBlock(Long blockId, int sort, int targetSort) {
        if (targetSort > sort) {
            pageBlockRepository.batchUpdateSortFromTopToBottom(sort, targetSort);
        } else {
            pageBlockRepository.batchUpdateSortFromBottomToTop(targetSort, sort);
        }
        pageBlockRepository.updateSortById(blockId, targetSort);
    }

    public long countByTypeAndPageLayoutId(BlockType blockType, Long pageLayoutId) {
        return pageBlockRepository.countByTypeAndPageLayoutId(blockType, pageLayoutId);
    }

    @Transactional
    public PageBlock addBlockToLayout(PageLayout pageLayout, boolean hasWaterfall, CreatePageBlockVM pageBlockVM) {
        var blocks = pageLayout.getPageBlocks();
        if (hasWaterfall) {
            var waterfallBlock = blocks.stream()
                    .filter(block -> block.getType() == BlockType.Waterfall)
                    .findFirst()
                    .orElseThrow();
            waterfallBlock.setSort(blocks.size() + 1);
        }
        final int sort = hasWaterfall ? blocks.size() : blocks.size() + 1;
        PageBlock pageBlock = new PageBlock();
        pageBlock.setTitle(pageBlockVM.title());
        pageBlock.setSort(sort);
        pageBlock.setConfig(pageBlockVM.config());
        pageBlock.setType(pageBlockVM.type());
        pageBlockVM.data().forEach(dataVM -> {
            PageBlockData pageBlockData = new PageBlockData();
            pageBlockData.setContent(dataVM.content());
            pageBlockData.setSort(pageBlock.getData().size() + 1);
            pageBlock.addData(pageBlockData);
        });
        pageLayout.addPageBlock(pageBlock);
        pageLayoutService.savePageLayout(pageLayout);
        return pageLayout.getPageBlocks().stream()
                .filter(block -> block.getSort() == sort)
                .findFirst().orElseThrow();
    }
}
