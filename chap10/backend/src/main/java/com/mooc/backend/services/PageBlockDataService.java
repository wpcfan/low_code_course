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

    public PageBlockData getPageBlockData(Long id) {
        return pageBlockDataRepository.findById(id).orElseThrow();
    }

    @Transactional
    public PageBlockData savePageBlockData(PageBlockData pageBlockData) {
        return pageBlockDataRepository.save(pageBlockData);
    }

    public void deletePageBlockData(PageBlock pageBlock, Long id) {
        PageBlockData pageBlockData = pageBlock.getData().stream()
                .filter(data -> data.getId().equals(id))
                .findFirst()
                .orElseThrow();
        final int sort = pageBlockData.getSort();
        pageBlock.removeData(pageBlockData);
        pageBlock.getData().stream()
                .filter(data -> data.getSort() > sort)
                .forEach(data -> data.setSort(data.getSort() - 1));
        pageBlockDataRepository.deleteById(id);
    }

    public void movePageBlockData(PageBlock pageBlock, Long dataId, Long targetDataId) {
        PageBlockData pageBlockData = pageBlock.getData().stream()
                .filter(data -> data.getId().equals(dataId))
                .findFirst()
                .orElseThrow();
        PageBlockData targetPageBlockData = pageBlock.getData().stream()
                .filter(data -> data.getId().equals(targetDataId))
                .findFirst()
                .orElseThrow();

        final int targetSort = targetPageBlockData.getSort();
        if (targetPageBlockData.getSort() > pageBlockData.getSort()) {
            pageBlock.getData().stream()
                    .filter(data -> data.getSort() > pageBlockData.getSort() && data.getSort() <= targetPageBlockData.getSort())
                    .forEach(data -> data.setSort(data.getSort() - 1));
        } else {
            pageBlock.getData().stream()
                    .filter(data -> data.getSort() < pageBlockData.getSort() && data.getSort() >= targetPageBlockData.getSort())
                    .forEach(data -> data.setSort(data.getSort() + 1));
        }
        pageBlockData.setSort(targetSort);
        pageBlockDataRepository.save(pageBlockData);
    }
}
