package com.mooc.backend.repositories;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Stream;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;

import com.mooc.backend.entities.PageLayout;
import com.mooc.backend.enumerations.PageStatus;
import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;

public interface PageLayoutRepository extends JpaRepository<PageLayout, Long>, JpaSpecificationExecutor<PageLayout> {
    long countByStatus(PageStatus status);

    Optional<PageLayout> findFirstByStatus(PageStatus status);

    boolean existsByTitleContainingAllIgnoreCase(String title);

    @EntityGraph(attributePaths = {"pageBlocks", "pageBlocks.data"})
    @Override
    Page<PageLayout> findAll(Pageable pageable);

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
}
