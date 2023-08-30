package com.mooc.backend.repositories;

import com.mooc.backend.entities.PageLayout;
import com.mooc.backend.enumerations.PageStatus;
import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Stream;

public interface PageLayoutRepository extends JpaRepository<PageLayout, Long> {
    long countByStatus(PageStatus status);

    Optional<PageLayout> findFirstByStatus(PageStatus status);

    boolean existsByTitleContainingAllIgnoreCase(String title);

    Stream<PageLayout> streamByPlatformAndPageTypeAndStatusAndStartTimeBeforeAndEndTimeAfter(Platform platform, PageType pageType, PageStatus status, LocalDateTime startTime, LocalDateTime endTime);

    List<PageLayout> findTop2ByPlatform(Platform platform);
    List<PageLayout> findByPlatformAndPageTypeAndStatusAndStartTimeBeforeAndEndTimeAfter(
            Platform platform,
            PageType pageType,
            PageStatus status,
            LocalDateTime time1,
            LocalDateTime time2
    );
}
