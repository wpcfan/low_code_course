package com.mooc.backend.entities;

import com.mooc.backend.enumerations.BlockType;
import com.mooc.backend.enumerations.ImageLinkType;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager;
import org.springframework.test.context.ActiveProfiles;

import static org.junit.jupiter.api.Assertions.assertEquals;
@ActiveProfiles("test")
@DataJpaTest
public class PageBlockDataTests {
    @Autowired
    private TestEntityManager entityManager;

    @Test
    public void givenPageBlockData_whenPersist_thenGetIsOk() {
        PageBlockData pageBlockData = new PageBlockData();
        ImageData imageData = new ImageData(
            "https://example.org/1.png",
            new ImageLink(ImageLinkType.Url, "https://example.org/xxx"), "title");
        pageBlockData.setSort(1);
        pageBlockData.setContent(imageData);
        entityManager.persist(pageBlockData);
        entityManager.flush();
        entityManager.clear();
        PageBlockData found = entityManager.find(PageBlockData.class, pageBlockData.getId());
        assertEquals(pageBlockData, found);
    }
}
