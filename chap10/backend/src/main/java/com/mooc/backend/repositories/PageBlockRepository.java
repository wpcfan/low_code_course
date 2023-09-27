package com.mooc.backend.repositories;

import com.mooc.backend.entities.PageBlock;
import com.mooc.backend.enumerations.BlockType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

public interface PageBlockRepository extends JpaRepository<PageBlock, Long> {
    long countByTypeAndPageLayoutId(BlockType blockType, Long pageLayoutId);

    // update mooc_page_blocks set sort = sort - 1 where sort > 1 and sort <= 4
    @Modifying(clearAutomatically = true)
    @Query("""
            update PageBlock pb set pb.sort = pb.sort - 1
                where pb.sort > :start and pb.sort <= :end
            """)
    int batchUpdateSortFromTopToBottom(int start, int end);

    @Modifying(clearAutomatically = true)
    @Query("""
            update PageBlock pb set pb.sort = pb.sort + 1
                where pb.sort >= :start and pb.sort < :end
            """)
    void batchUpdateSortFromBottomToTop(int start, int end);

    @Modifying
    @Query("""
            update PageBlock pb set pb.sort = :targetSort
                where pb.id = :blockId
            """)
    int updateSortById(Long blockId, int targetSort);
}
