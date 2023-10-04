package com.mooc.backend.entities;

import com.mooc.backend.enumerations.BlockType;
import com.mooc.backend.enumerations.PageStatus;
import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;
import jakarta.transaction.Transactional;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager;
import org.springframework.test.context.ActiveProfiles;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotEquals;

@ActiveProfiles("test")
@DataJpaTest
public class PageLayoutTests {

    @Autowired
    private TestEntityManager entityManager;

    @Transactional
    @Test
    public void givenPageLayout_whenPersist_thenGetIsOk() {
        PageLayout pageLayout = new PageLayout();
        pageLayout.setTitle("Test PageLayout");
        pageLayout.setConfig(new PageConfig());
        pageLayout.setPageType(PageType.Home);
        pageLayout.setPlatform(Platform.APP);
        pageLayout.setStatus(PageStatus.DRAFT);
        entityManager.persist(pageLayout);
        entityManager.flush();
        entityManager.clear();
        PageLayout found = entityManager.find(PageLayout.class, pageLayout.getId());
        assertEquals(pageLayout, found);

        PageLayout pageLayout1 = new PageLayout();
        pageLayout1.setConfig(new PageConfig());
        pageLayout1.setPageType(PageType.Category);
        pageLayout1.setPlatform(Platform.WEB);
        pageLayout1.setStatus(PageStatus.ARCHIVED);

        assertNotEquals(found, pageLayout1);
    }

    @Transactional
    @Test
    public void givenPageLayoutAndPageBlocks_whenPersist_thenGetIsOk() {
        PageLayout pageLayout = new PageLayout();
        pageLayout.setTitle("Test PageLayout");
        pageLayout.setConfig(new PageConfig());
        pageLayout.setPageType(PageType.Home);
        pageLayout.setPlatform(Platform.APP);
        pageLayout.setStatus(PageStatus.DRAFT);

        PageBlock pageBlock1 = new PageBlock();
        pageBlock1.setTitle("Test Banner");
        pageBlock1.setType(BlockType.Banner);
        pageBlock1.setConfig(new BlockConfig());
        pageBlock1.setPageLayout(pageLayout);
        pageBlock1.setSort(1);
        pageLayout.addPageBlock(pageBlock1);

        PageBlock pageBlock2 = new PageBlock();
        pageBlock2.setTitle("Test ImageRow");
        pageBlock2.setType(BlockType.ImageRow);
        pageBlock2.setConfig(new BlockConfig());
        pageBlock2.setPageLayout(pageLayout);
        pageBlock2.setSort(2);
        pageLayout.addPageBlock(pageBlock2);

        entityManager.persist(pageLayout);
        entityManager.flush();
        entityManager.clear();
        PageLayout found = entityManager.find(PageLayout.class, pageLayout.getId());
        assertEquals(pageLayout, found);
        assertEquals(2, found.getPageBlocks().size());
        assertEquals(pageBlock1, found.getPageBlocks().stream().findFirst().orElseThrow());
        assertEquals(pageBlock2, found.getPageBlocks().stream().skip(1).findFirst().orElseThrow());
    }

    @Test
    public void givenPageBlocksWithDifferentSort_whenPersist_thenGetIsOk() {
        PageLayout pageLayout = new PageLayout();
        pageLayout.setTitle("Test PageLayout");
        pageLayout.setConfig(new PageConfig());
        pageLayout.setPageType(PageType.Home);
        pageLayout.setPlatform(Platform.APP);
        pageLayout.setStatus(PageStatus.DRAFT);

        PageBlock pageBlock1 = new PageBlock();
        pageBlock1.setTitle("Test Banner");
        pageBlock1.setType(BlockType.Banner);
        pageBlock1.setConfig(new BlockConfig());
        pageBlock1.setSort(2);
        pageBlock1.setPageLayout(pageLayout);
        pageLayout.addPageBlock(pageBlock1);

        PageBlock pageBlock2 = new PageBlock();
        pageBlock2.setTitle("Test ImageRow");
        pageBlock2.setType(BlockType.ImageRow);
        pageBlock2.setConfig(new BlockConfig());
        pageBlock2.setSort(1);
        pageBlock2.setPageLayout(pageLayout);
        pageLayout.addPageBlock(pageBlock2);

        entityManager.persist(pageLayout);
        entityManager.flush();
        entityManager.clear();
        PageLayout found = entityManager.find(PageLayout.class, pageLayout.getId());
        assertEquals(pageLayout, found);
        assertEquals(2, found.getPageBlocks().size());
        assertEquals(pageBlock2, found.getPageBlocks().stream().findFirst().orElseThrow());
        assertEquals(pageBlock1, found.getPageBlocks().stream().skip(1).findFirst().orElseThrow());
    }
}
