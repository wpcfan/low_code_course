package com.mooc.backend.repositories;

import com.mooc.backend.entities.PageLayout;
import com.mooc.backend.enumerations.PageStatus;
import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;
import org.springframework.data.jpa.repository.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Stream;

public interface PageLayoutRepository extends JpaRepository<PageLayout, Long>, JpaSpecificationExecutor<PageLayout> {
    long countByStatus(PageStatus status);

    Optional<PageLayout> findFirstByStatus(PageStatus status);

    boolean existsByTitleContainingAllIgnoreCase(String title);

    @Query("""
            select pl from PageLayout pl
                left join fetch pl.pageBlocks pb
                left join fetch pb.data pbd
                where pl.id = :id
                """)
//    @EntityGraph(attributePaths = {"pageBlocks", "pageBlocks.data"})
    @Override
    Optional<PageLayout> findById(Long id);

    @Query("""
            select pl from PageLayout pl
                where pl.platform = :platform
                and pl.pageType = :pageType
                and pl.status = :status
                and pl.startTime <= :requestTime
                and pl.endTime >= :requestTime
                """)
    Stream<PageLayout> streamByConditions(Platform platform, PageType pageType, PageStatus status,
            LocalDateTime requestTime);

    List<PageLayout> findTop2ByPlatform(Platform platform);

    @EntityGraph(attributePaths = {"pageBlocks", "pageBlocks.data"})
    List<PageLayout> findByPlatformAndPageTypeAndStatusAndStartTimeBeforeAndEndTimeAfter(
            Platform platform,
            PageType pageType,
            PageStatus status,
            LocalDateTime time1,
            LocalDateTime time2);

    @Query("""
            select count(pl) from PageLayout pl
                where pl.platform = :platform
                and pl.pageType = :pageType
                and pl.status = com.mooc.backend.enumerations.PageStatus.PUBLISHED
                and pl.startTime <= :time
                and pl.endTime >= :time
            """)
    long findByPublishTimeConflict(LocalDateTime time, Platform platform, PageType pageType);

    @Modifying
    @Query("""
            update PageLayout pl
                set pl.status = com.mooc.backend.enumerations.PageStatus.ARCHIVED
                where pl.status = com.mooc.backend.enumerations.PageStatus.PUBLISHED
                and pl.endTime is not null
                and pl.endTime < :time
            """)
    int updatePageStatusToArchived(LocalDateTime time);
}
