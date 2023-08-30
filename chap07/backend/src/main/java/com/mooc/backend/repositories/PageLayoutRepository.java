package com.mooc.backend.repositories;

import com.mooc.backend.entities.PageLayout;
import com.mooc.backend.enumerations.PageStatus;
import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDateTime;
import java.util.List;

public interface PageLayoutRepository extends JpaRepository<PageLayout, Long> {
    List<PageLayout> findTop2ByPlatform(Platform platform);
    List<PageLayout> findByPlatformAndPageTypeAndStatusAndStartTimeBeforeAndEndTimeAfter(
            Platform platform,
            PageType pageType,
            PageStatus status,
            LocalDateTime time1,
            LocalDateTime time2
    );
}
