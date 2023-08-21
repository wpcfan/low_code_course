package com.mooc.backend.entities;

import com.mooc.backend.enumerations.ImageLinkType;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager;
import org.springframework.test.context.ActiveProfiles;

import static org.junit.Assert.assertEquals;

@ActiveProfiles("test")
@DataJpaTest
public class PageBlockDataTests {
    @Autowired
    private TestEntityManager entityManager;

    @Test
    public void givenPageBlockData_whenPersist_thenGetIsOk() {
        PageBlockData pageBlockData = new PageBlockData();
        ImageData data = new ImageData("http://localhost:8080/1.png", new ImageLink(ImageLinkType.Url, "http://localhost:8080/1/target"), "title");
        pageBlockData.setContent(data);
        pageBlockData.setSort(1);
        entityManager.persist(pageBlockData);
        entityManager.flush();
        PageBlockData found = entityManager.find(PageBlockData.class, pageBlockData.getId());
        assertEquals(pageBlockData, found);
        assertEquals(data, found.getContent());
    }
}
