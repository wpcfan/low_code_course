package com.mooc.backend.services;

import com.mooc.backend.entities.PageBlockData;
import com.mooc.backend.repositories.PageBlockDataRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@RequiredArgsConstructor
@Service
public class PageBlockDataService {
    private final PageBlockDataRepository pageBlockDataRepository;

    public PageBlockData getPageBlockData(Long id) {
        return pageBlockDataRepository.findById(id).orElseThrow();
    }

    public PageBlockData savePageBlockData(PageBlockData pageBlockData) {
        return pageBlockDataRepository.save(pageBlockData);
    }

    public void deletePageBlockData(Long id) {
        pageBlockDataRepository.deleteById(id);
    }
}
