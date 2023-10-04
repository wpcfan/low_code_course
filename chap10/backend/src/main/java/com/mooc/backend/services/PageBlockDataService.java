package com.mooc.backend.services;

import com.mooc.backend.entities.PageBlock;
import com.mooc.backend.entities.PageBlockData;
import com.mooc.backend.repositories.PageBlockDataRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@RequiredArgsConstructor
@Service
public class PageBlockDataService {
    private final PageBlockDataRepository pageBlockDataRepository;
    private final PageBlockService pageBlockService;
    public PageBlockData getPageBlockData(Long id) {
        return pageBlockDataRepository.findById(id).orElseThrow();
    }

    @Transactional
    public PageBlockData savePageBlockData(PageBlockData pageBlockData) {
        return pageBlockDataRepository.save(pageBlockData);
    }

    @Transactional
    public PageBlock deletePageBlockData(Long blockId, Long blockDataId) {
        PageBlock pageBlock = pageBlockService.getPageBlock(blockId);
        PageBlockData pageBlockData = pageBlock.getData().stream()
                .filter(data -> data.getId().equals(blockDataId))
                .findFirst()
                .orElseThrow();
        final int sort = pageBlockData.getSort();
        pageBlock.removeData(pageBlockData);
        pageBlock.getData().stream()
                .filter(data -> data.getSort() > sort)
                .forEach(data -> data.setSort(data.getSort() - 1));
        return pageBlockService.savePageBlock(pageBlock);
    }

    @Transactional
    public void movePageBlockData(Long blockId, Long dataId, Long targetDataId) {
        PageBlock pageBlock = pageBlockService.getPageBlock(blockId);
        PageBlockData pageBlockData = pageBlock.getData().stream()
                .filter(data -> data.getId().equals(dataId))
                .findFirst()
                .orElseThrow();
        PageBlockData targetPageBlockData = pageBlock.getData().stream()
                .filter(data -> data.getId().equals(targetDataId))
                .findFirst()
                .orElseThrow();

        final int targetSort = targetPageBlockData.getSort();
        final int sort = pageBlockData.getSort();
        if (targetSort == sort) {
            return;
        }
        if (targetSort > sort) {
            pageBlock.getData().stream()
                    .filter(data -> data.getSort() > sort && data.getSort() <= targetSort)
                    .forEach(data -> data.setSort(data.getSort() - 1));
        } else {
            pageBlock.getData().stream()
                    .filter(data -> data.getSort() < sort && data.getSort() >= targetSort)
                    .forEach(data -> data.setSort(data.getSort() + 1));
        }
        pageBlockData.setSort(targetSort);
        pageBlockService.savePageBlock(pageBlock);
    }
}
