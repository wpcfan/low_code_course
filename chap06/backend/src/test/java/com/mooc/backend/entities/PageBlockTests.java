package com.mooc.backend.entities;

import com.mooc.backend.enumerations.BlockType;
import com.mooc.backend.enumerations.ImageLinkType;
import jakarta.transaction.Transactional;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager;
import org.springframework.test.context.ActiveProfiles;

import static org.junit.jupiter.api.Assertions.assertEquals;

@ActiveProfiles("test")
@DataJpaTest
public class PageBlockTests {
    @Autowired
    private TestEntityManager entityManager;

    @Transactional
    @Test
    public void givenPageBlock_whenPersist_thenGetIsOk() {
        PageBlock pageBlock = new PageBlock();
        pageBlock.setType(BlockType.Banner);
        pageBlock.setConfig(new BlockConfig());
        pageBlock.setSort(1);
        ImageData imageData = new ImageData("http://localhost:8080/1.png", new ImageLink(ImageLinkType.Url, "http://localhost:8080/1/target"), "title");
        PageBlockData pageBlockData = new PageBlockData();
        pageBlockData.setContent(imageData);
        pageBlockData.setSort(1);
        pageBlock.addData(pageBlockData);
        entityManager.persist(pageBlock);
        entityManager.flush();
        entityManager.clear();
        PageBlock found = entityManager.find(PageBlock.class, pageBlock.getId());
        assertEquals(pageBlock, found);
        assertEquals(pageBlockData, found.getData().stream().findFirst().get());
        assertEquals(imageData, found.getData().stream().findFirst().get().getContent());
    }
}
