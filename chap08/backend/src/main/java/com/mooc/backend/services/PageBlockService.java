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
}
