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
import org.springframework.test.context.TestPropertySource;

import static org.junit.jupiter.api.Assertions.*;

@TestPropertySource(
    properties = {
        "hostname=localhost"
    }
)
@SpringBootTest
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
        assertNotNull(found.getCreatedAt());
        assertNotNull(found.getUpdatedAt());

        PageLayout pageLayout1 = new PageLayout();
        pageLayout.setConfig(new PageConfig());
        pageLayout.setPageType(PageType.Category);
        pageLayout.setPlatform(Platform.WEB);
        pageLayout.setStatus(PageStatus.ARCHIVED);

        assertNotEquals(found, pageLayout1);
    }
}
