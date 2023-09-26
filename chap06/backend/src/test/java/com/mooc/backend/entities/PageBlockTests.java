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

        ImageData imageData1 = new ImageData(
            "https://example.org/1.png",
            new ImageLink(ImageLinkType.Url, "https://example.org/xxx"), "title");

        ImageData imageData2 = new ImageData(
            "https://example.org/1.png",
            new ImageLink(ImageLinkType.Url, "https://example.org/xxx"), "title");

        PageBlockData data1 = new PageBlockData();
        data1.setSort(1);
        data1.setContent(imageData1);

        PageBlockData data2 = new PageBlockData();
        data2.setSort(2);
        data2.setContent(imageData2);

        pageBlock.addData(data1);
        pageBlock.addData(data2);

        entityManager.persist(data1);
        entityManager.persist(data2);
        entityManager.persist(pageBlock);
        entityManager.flush();
        entityManager.clear();
        PageBlock found = entityManager.find(PageBlock.class, pageBlock.getId());
        assertEquals(pageBlock, found);
        assertEquals(2, found.getData().size());
        assertEquals(1, found.getData().stream().findFirst().get().getSort());
        assertEquals(2, found.getData().stream().skip(1).findFirst().get().getSort());
    }
}
