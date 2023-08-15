package com.mooc.backend.entities;

import com.mooc.backend.enumerations.PageStatus;
import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotEquals;

@DataJpaTest
public class PageLayoutTests {

    @Autowired
    private TestEntityManager entityManager;

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
        pageLayout.setConfig(new PageConfig());
        pageLayout.setPageType(PageType.Category);
        pageLayout.setPlatform(Platform.WEB);
        pageLayout.setStatus(PageStatus.ARCHIVED);

        assertNotEquals(found, pageLayout1);
    }
}
