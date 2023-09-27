package com.mooc.backend.repositories;

import com.mooc.backend.entities.PageBlock;
import com.mooc.backend.enumerations.BlockType;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PageBlockRepository extends JpaRepository<PageBlock, Long> {
    long countByTypeAndPageLayoutId(BlockType blockType, Long pageLayoutId);
}
