package com.mooc.backend.repositories;

import com.mooc.backend.entities.PageLayout;
import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface PageLayoutRepository extends JpaRepository<PageLayout, Long> {
    List<PageLayout> findByPlatformAndPageType(Platform platform, PageType pageType);
}
