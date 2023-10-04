package com.mooc.backend.repositories;

import com.mooc.backend.entities.BlockConfig;
import com.mooc.backend.entities.PageBlock;
import com.mooc.backend.entities.PageConfig;
import com.mooc.backend.entities.PageLayout;
import com.mooc.backend.enumerations.BlockType;
import com.mooc.backend.enumerations.PageStatus;
import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.redisson.spring.starter.RedissonAutoConfiguration;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.cache.CacheAutoConfiguration;
import org.springframework.boot.autoconfigure.data.redis.RedisAutoConfiguration;
import org.springframework.boot.autoconfigure.data.redis.RedisRepositoriesAutoConfiguration;
import org.springframework.boot.autoconfigure.flyway.FlywayAutoConfiguration;
import org.springframework.boot.autoconfigure.liquibase.LiquibaseAutoConfiguration;
import org.springframework.boot.autoconfigure.sql.init.SqlInitializationAutoConfiguration;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager;
import org.springframework.test.annotation.DirtiesContext;
import org.springframework.test.context.ActiveProfiles;

import static org.junit.jupiter.api.Assertions.assertEquals;

@ActiveProfiles("test")
@DirtiesContext(classMode = DirtiesContext.ClassMode.AFTER_EACH_TEST_METHOD)
@DataJpaTest(excludeAutoConfiguration = {
        SqlInitializationAutoConfiguration.class,
        LiquibaseAutoConfiguration.class,
        FlywayAutoConfiguration.class,
        CacheAutoConfiguration.class,
        RedisAutoConfiguration.class,
        RedisRepositoriesAutoConfiguration.class,
        RedissonAutoConfiguration.class,
})
public class PageBlockRepositoryTests {

    @Autowired
    private TestEntityManager entityManager;

    @Autowired
    private PageBlockRepository pageBlockRepository;

    PageLayout pageLayout;

    @BeforeEach
    public void setUp() {
        var pageConfig = new PageConfig();
        pageConfig.setBaselineScreenWidth(375.0);
        pageLayout = PageLayout.builder()
                .title("Test PageLayout")
                .config(pageConfig)
                .status(PageStatus.DRAFT)
                .platform(Platform.APP)
                .pageType(PageType.Home)
                .build();
        var blockConfig = BlockConfig.builder()
                .horizontalPadding(12.0)
                .verticalPadding(8.0)
                .horizontalSpacing(8.0)
                .verticalSpacing(8.0)
                .build();
        var bannerBlock = PageBlock.builder()
                .config(blockConfig)
                .type(BlockType.Banner)
                .title("Test Banner")
                .sort(1)
                .build();
        var oneRowOneImageBlock = PageBlock.builder()
                .config(blockConfig)
                .type(BlockType.ImageRow)
                .title("Test OneRowOneImage")
                .sort(2)
                .build();
        var oneRowTwoImageBlock = PageBlock.builder()
                .config(blockConfig)
                .type(BlockType.ImageRow)
                .title("Test OneRowTwoImage")
                .sort(3)
                .build();
        var oneRowThreeImageBlock = PageBlock.builder()
                .config(blockConfig)
                .type(BlockType.ImageRow)
                .title("Test OneRowThreeImage")
                .sort(4)
                .build();
        var oneRowOneProductBlock = PageBlock.builder()
                .config(blockConfig)
                .type(BlockType.ProductRow)
                .title("Test OneRowOneProduct")
                .sort(5)
                .build();
        pageLayout.addPageBlock(bannerBlock);
        pageLayout.addPageBlock(oneRowOneImageBlock);
        pageLayout.addPageBlock(oneRowTwoImageBlock);
        pageLayout.addPageBlock(oneRowThreeImageBlock);
        pageLayout.addPageBlock(oneRowOneProductBlock);
        entityManager.persist(bannerBlock);
        entityManager.persist(oneRowOneImageBlock);
        entityManager.persist(oneRowTwoImageBlock);
        entityManager.persist(oneRowThreeImageBlock);
        entityManager.persist(oneRowOneProductBlock);
        entityManager.persist(pageLayout);
        entityManager.flush();
    }

    @AfterEach
    public void tearDown() {
        entityManager.clear();
    }

    @Test
    public void givenBlockTypeAndPageLayoutId_whenCountByTypeAndPageLayoutId_thenReturnCount() {
        var count = pageBlockRepository.countByTypeAndPageLayoutId(BlockType.Banner, pageLayout.getId());
        assertEquals(1L, count);
    }

    @Test
    public void givenStartAndEnd_whenBatchUpdateSortFromTopToBottom_thenUpdateCount() {
        var count = pageBlockRepository.batchUpdateSortFromTopToBottom(1, 4);
        assertEquals(3, count);
    }

    @Test
    public void givenStartAndEnd_whenBatchUpdateSortFromBottomToTop_thenUpdateCount() {
        var count = pageBlockRepository.batchUpdateSortFromBottomToTop(1, 4);
        assertEquals(3, count);
    }

    @Test
    public void givenBlockIdAndTargetSort_whenUpdateSortById_thenUpdateCount() {
        var count = pageBlockRepository.updateSortById(1L, 2);
        assertEquals(1, count);
        // 请考虑为什么这里需要清除 EntityManager 的缓存
        // @Modifying 一般用于更新或删除操作，这些操作不会立即生效，而是在事务提交时才会生效
        // 如果不清除 EntityManager 的缓存，那么在这个测试方法中，EntityManager 会认为 sort 的值还是 1
        entityManager.clear();
        assertEquals(2, pageBlockRepository.findById(1L).orElseThrow().getSort());
    }
}
