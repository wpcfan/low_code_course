package com.mooc.backend.repositories;

import com.mooc.backend.entities.*;
import com.mooc.backend.enumerations.BlockType;
import com.mooc.backend.enumerations.ImageLinkType;
import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager;
import org.springframework.test.context.ActiveProfiles;

import java.util.Set;

@ActiveProfiles("test")
@DataJpaTest
public class PageLayoutRepositoryTest {

    @Autowired
    private TestEntityManager entityManager;

    @Autowired
    private PageLayoutRepository pageLayoutRepository;

    private PageLayout page1;
    private PageLayout page2;
    private PageLayout page3;
    private PageLayout page4;

    @BeforeEach
    public void setUp() {
        var linkBaidu = ImageLink.builder()
                .type(ImageLinkType.Url)
                .value("https://www.baidu.com")
                .build();
        var linkSina = ImageLink.builder()
                .type(ImageLinkType.Url)
                .value("https://www.sina.com.cn")
                .build();
        var bannerImage = "https://via.placeholder.com/400/50";
        var rowImage = "https://via.placeholder.com/120/50";
        var pageConfig = PageConfig.builder()
                .baselineScreenWidth(375.0)
                .build();
        var blockConfig = BlockConfig.builder()
                .horizontalPadding(12.0)
                .verticalPadding(8.0)
                .horizontalSpacing(8.0)
                .verticalSpacing(8.0)
                .build();
        var bannerImageData1 = new ImageData(bannerImage, linkBaidu, "Test Image 1");

        var bannerImageData2 = new ImageData(bannerImage, linkSina, "Test Image 2");
        var rowImageData1 = new ImageData(rowImage, linkBaidu, "Test Image 1");
        var rowImageData2 = new ImageData(rowImage, linkBaidu, "Test Image 2");
        var rowImageData3 = new ImageData(rowImage, linkBaidu, "Test Image 3");
        var bannerBlockData1 = PageBlockData.builder()
                .sort(1)
                .content(bannerImageData1)
                .build();
        entityManager.persist(bannerBlockData1);
        var bannerBlockData2 = PageBlockData.builder()
                .sort(2)
                .content(bannerImageData2)
                .build();
        entityManager.persist(bannerBlockData2);
        var pinnedHeader = PageBlock.builder()
                .sort(1)
                .type(BlockType.Banner)
                .config(blockConfig)
                .build();
        pinnedHeader.addData(bannerBlockData1);
        pinnedHeader.addData(bannerBlockData2);
        entityManager.persist(pinnedHeader);

        var rowBlockData1 = PageBlockData.builder()
                .sort(1)
                .content(rowImageData1)
                .build();
        entityManager.persist(rowBlockData1);
        var rowBlockData2 = PageBlockData.builder()
                .sort(2)
                .content(rowImageData2)
                .build();
        entityManager.persist(rowBlockData2);
        var rowBlockData3 = PageBlockData.builder()
                .sort(3)
                .content(rowImageData3)
                .build();
        entityManager.persist(rowBlockData3);
        var imageRow = PageBlock.builder()
                .sort(2)
                .type(BlockType.ImageRow)
                .config(blockConfig)
                .build();
        imageRow.addData(rowBlockData1);
        imageRow.addData(rowBlockData2);
        imageRow.addData(rowBlockData3);
        entityManager.persist(imageRow);

        var productBlockData1 = new ProductData(
                1L,
                "sku_001",
                "xPhone手机",
                "这是一段商品描述",
                Set.of("https://picsum.photos/200/300"),
                "¥1234.00",
                "¥1300.00"
        );
        var productBlockData2 = new ProductData(
                2L,
                "sku_002",
                "xPhone手机",
                "这是一段商品描述",
                Set.of("https://picsum.photos/200/300"),
                "¥1234.00",
                "¥1300.00"
        );
        var productData1 = PageBlockData.builder()
                .sort(1)
                .content(productBlockData1)
                .build();
        entityManager.persist(productData1);
        var productData2 = PageBlockData.builder()
                .sort(2)
                .content(productBlockData2)
                .build();
        entityManager.persist(productData2);
        var productRow = PageBlock.builder()
                .sort(3)
                .type(BlockType.ProductRow)
                .config(blockConfig)
                .build();

        productRow.addData(productData1);
        productRow.addData(productData2);
        entityManager.persist(productRow);

        page1 = PageLayout.builder()
                .pageType(PageType.Home)
                .platform(Platform.APP)
                .config(pageConfig)
                .title("Test Page 1")
                .build();

        page1.addPageBlock(pinnedHeader);
        page1.addPageBlock(imageRow);
        page1.addPageBlock(productRow);

        entityManager.persist(page1);

        page2 = PageLayout.builder()
                .pageType(PageType.Home)
                .platform(Platform.APP)
                .config(pageConfig)
                .title("Test Page 2")
                .build();

        page2.addPageBlock(pinnedHeader);
        page2.addPageBlock(imageRow);
        page2.addPageBlock(imageRow);
        page2.addPageBlock(productRow);
        page2.addPageBlock(productRow);

        entityManager.persist(page2);

        page3 = PageLayout.builder()
                .pageType(PageType.Category)
                .platform(Platform.APP)
                .config(pageConfig)
                .title("Test Page 3")
                .build();

        page3.addPageBlock(pinnedHeader);
        page3.addPageBlock(imageRow);
        page3.addPageBlock(imageRow);
        page3.addPageBlock(productRow);
        page3.addPageBlock(productRow);

        entityManager.persist(page3);

        page4 = PageLayout.builder()
                .pageType(PageType.Category)
                .platform(Platform.WEB)
                .config(pageConfig)
                .title("Test Page 4")
                .build();

        page4.addPageBlock(imageRow);
        page4.addPageBlock(productRow);
        page4.addPageBlock(imageRow);
        page4.addPageBlock(productRow);

        entityManager.persist(page4);
        entityManager.flush();
    }

    @AfterEach
    void afterEach() {
        entityManager.clear();
    }

    @Test
    public void givenPageLayout_whenSave_thenGetOk() {
        var pageLayout = PageLayout.builder()
                .pageType(PageType.Home)
                .platform(Platform.APP)
                .config(new PageConfig())
                .title("Test Page 5")
                .build();
        pageLayoutRepository.save(pageLayout);
        var found = pageLayoutRepository.findById(pageLayout.getId());
        assert found.isPresent();
        assert found.get().equals(pageLayout);
    }

}
