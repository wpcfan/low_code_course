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
        pageLayout.setConfig(new PageConfig());
        pageLayout.setPageType(PageType.Home);
        pageLayout.setPlatform(Platform.APP);
        pageLayout.setStatus(PageStatus.DRAFT);
        entityManager.persist(pageLayout);
        entityManager.flush();
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
        pageLayout.setConfig(new PageConfig());
        pageLayout.setPageType(PageType.Home);
        pageLayout.setPlatform(Platform.APP);
        pageLayout.setStatus(PageStatus.DRAFT);

        PageBlock pageBlock = new PageBlock();
        pageBlock.setType(BlockType.Banner);
        pageBlock.setConfig(new BlockConfig());
        pageBlock.setSort(1);
        pageBlock.setPageLayout(pageLayout);
        pageLayout.getPageBlocks().add(pageBlock);

//        entityManager.persist(pageBlock);
        entityManager.persist(pageLayout);
        entityManager.flush();
        entityManager.clear();
        PageLayout found = entityManager.find(PageLayout.class, pageLayout.getId());
        assertEquals(pageLayout.getId(), found.getId());
        assertEquals(pageBlock, found.getPageBlocks().stream().findFirst().get());

    }
}
