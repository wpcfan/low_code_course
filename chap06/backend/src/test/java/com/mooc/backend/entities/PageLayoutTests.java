package com.mooc.backend.entities;

import com.mooc.backend.enumerations.PageStatus;
import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;
import jakarta.persistence.EntityManager;
import jakarta.transaction.Transactional;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.annotation.PropertySource;
import org.springframework.context.annotation.PropertySources;
import org.springframework.test.context.ActiveProfiles;

import static org.junit.jupiter.api.Assertions.*;

@ActiveProfiles("test")
@DataJpaTest
public class PageLayoutTests {

    @Autowired
    private EntityManager entityManager;

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
}
