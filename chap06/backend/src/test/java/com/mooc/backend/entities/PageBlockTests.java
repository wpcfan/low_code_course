package com.mooc.backend.entities;

import com.mooc.backend.enumerations.BlockType;
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
        entityManager.persist(pageBlock);
        entityManager.flush();
        PageBlock found = entityManager.find(PageBlock.class, pageBlock.getId());
        assertEquals(pageBlock, found);
    }
}
