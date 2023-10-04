package com.mooc.backend.services;

import com.mooc.backend.entities.*;
import com.mooc.backend.enumerations.*;
import com.mooc.backend.repositories.PageBlockRepository;
import com.mooc.backend.rest.vm.CreateOrUpdatePageBlockDataVM;
import com.mooc.backend.rest.vm.CreatePageBlockVM;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentMatchers;
import org.mockito.Mockito;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.test.context.junit.jupiter.SpringExtension;

import java.util.List;
import java.util.SortedSet;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;

@ExtendWith(SpringExtension.class)
public class PageBlockServiceTests {

    @MockBean
    private PageBlockRepository pageBlockRepository;

    @MockBean
    private PageLayoutService pageLayoutService;

    private PageBlockService pageBlockService;

    private PageLayout pageLayout;

    @BeforeEach
    public void setUp() {
        pageBlockService = new PageBlockService(pageBlockRepository, pageLayoutService);
        var pageConfig = new PageConfig();
        pageConfig.setBaselineScreenWidth(375.0);
        pageLayout = PageLayout.builder()
                .id(1L)
                .config(pageConfig)
                .title("Test PageLayout")
                .status(PageStatus.DRAFT)
                .pageType(PageType.Home)
                .platform(Platform.APP)
                .build();
        var blockConfig = BlockConfig.builder()
                .horizontalPadding(10.0)
                .verticalPadding(10.0)
                .build();
        var bannerContent1 = new ImageData(
                "http://localhost:8080/1.png",
                new ImageLink(ImageLinkType.Url, "http://localhost:8080/1/target"),
                "title 1"
        );
        var bannerContent2 = new ImageData(
                "http://localhost:8080/2.png",
                new ImageLink(ImageLinkType.Url, "http://localhost:8080/2/target"),
                "title 2"
        );

        var bannerData1 = PageBlockData.builder()
                .id(1L)
                .sort(1)
                .content(bannerContent1)
                .build();

        var bannerData2 = PageBlockData.builder()
                .id(2L)
                .sort(2)
                .content(bannerContent2)
                .build();
        var bannerBlock = PageBlock.builder()
                .id(1L)
                .sort(1)
                .title("Test Banner Block")
                .config(blockConfig)
                .type(BlockType.Banner)
                .build();
        bannerBlock.addData(bannerData1);
        bannerBlock.addData(bannerData2);
        pageLayout.addPageBlock(bannerBlock);

        var oneRowOneImageContent1 = new ImageData(
                "http://localhost:8080/3.png",
                new ImageLink(ImageLinkType.Url, "http://localhost:8080/3/target"),
                "title 3"
        );
        var oneRowOneImageData1 = PageBlockData.builder()
                .id(3L)
                .sort(1)
                .content(oneRowOneImageContent1)
                .build();
        var oneRowOneImageBlock = PageBlock.builder()
                .id(2L)
                .sort(2)
                .title("Test OneRowOneImage Block")
                .config(blockConfig)
                .type(BlockType.ImageRow)
                .build();
        oneRowOneImageBlock.addData(oneRowOneImageData1);
        pageLayout.addPageBlock(oneRowOneImageBlock);

        var oneRowTwoImageContent1 = new ImageData(
                "http://localhost:8080/4.png",
                new ImageLink(ImageLinkType.Url, "http://localhost:8080/4/target"),
                "title 4"
        );
        var oneRowTwoImageContent2 = new ImageData(
                "http://localhost:8080/5.png",
                new ImageLink(ImageLinkType.Url, "http://localhost:8080/5/target"),
                "title 5"
        );
        var oneRowTwoImageData1 = PageBlockData.builder()
                .id(4L)
                .sort(1)
                .content(oneRowTwoImageContent1)
                .build();
        var oneRowTwoImageData2 = PageBlockData.builder()
                .id(5L)
                .sort(2)
                .content(oneRowTwoImageContent2)
                .build();
        var oneRowTwoImageBlock = PageBlock.builder()
                .id(3L)
                .sort(3)
                .title("Test OneRowTwoImage Block")
                .config(blockConfig)
                .type(BlockType.ImageRow)
                .build();
        oneRowTwoImageBlock.addData(oneRowTwoImageData1);
        oneRowTwoImageBlock.addData(oneRowTwoImageData2);
        pageLayout.addPageBlock(oneRowTwoImageBlock);
    }

    @Test
    public void givenPageLayoutIdAndPageBlockId_whenDelete_thenDeleteIsOk() {
        Mockito.when(pageLayoutService.getPageLayout(pageLayout.getId())).thenReturn(pageLayout);
        // 注意，我们需要返回通过 savePageLayout 保存的 pageLayout，而不是我们预先创建的 pageLayout
        // 通过 thenAnswer 方法，我们可以获取到 savePageLayout 方法的参数，然后返回该参数
        Mockito.when(pageLayoutService.savePageLayout(ArgumentMatchers.any(PageLayout.class)))
                        .thenAnswer(i -> i.getArguments()[0]);

        pageBlockService.deletePageBlock(pageLayout.getId(), 2L);
        // 确认是否已经删除了 oneRowOneImageBlock，返回的 pageLayout 中不应该包含 oneRowOneImageBlock
        assertEquals(2, pageLayout.getPageBlocks().size());
        assertEquals(BlockType.Banner, pageLayout.getPageBlocks().stream().findFirst().orElseThrow().getType());
        assertEquals(BlockType.ImageRow, pageLayout.getPageBlocks().stream().skip(1).findFirst().orElseThrow().getType());
        assertEquals(1L, pageLayout.getPageBlocks().stream().findFirst().orElseThrow().getId());
        assertEquals(3L, pageLayout.getPageBlocks().stream().skip(1).findFirst().orElseThrow().getId());
        assertEquals(1, pageLayout.getPageBlocks().stream().filter(block -> block.getId().equals(1L)).findFirst().orElseThrow().getSort());
        assertEquals(2, pageLayout.getPageBlocks().stream().filter(block -> block.getId().equals(3L)).findFirst().orElseThrow().getSort());
    }

    @Test
    public void givenBlockIdAndSortAndTargetSort_whenSortGreaterThanTargetSort_thenBatchUpdateSortFromTopToBottomIsOk() {
        final int sort = 2;
        final int targetSort = 1;
        final Long blockId = 1L;
        Mockito.when(pageBlockRepository.batchUpdateSortFromBottomToTop(targetSort, sort)).thenReturn(1);
        Mockito.when(pageBlockRepository.updateSortById(blockId, targetSort)).thenReturn(1);
        pageBlockService.movePageBlock(blockId, sort, targetSort);
        Mockito.verify(pageBlockRepository, Mockito.times(1))
                .batchUpdateSortFromBottomToTop(targetSort, sort);
        Mockito.verify(pageBlockRepository, Mockito.times(1))
                .updateSortById(blockId, targetSort);
    }

    @Test
    public void givenBlockIdAndSortAndTargetSort_whenSortLessThanTargetSort_thenBatchUpdateSortFromBottomToTopIsOk() {
        final int sort = 1;
        final int targetSort = 2;
        final Long blockId = 1L;
        Mockito.when(pageBlockRepository.batchUpdateSortFromTopToBottom(sort, targetSort)).thenReturn(1);
        Mockito.when(pageBlockRepository.updateSortById(blockId, targetSort)).thenReturn(1);
        pageBlockService.movePageBlock(blockId, sort, targetSort);
        Mockito.verify(pageBlockRepository, Mockito.times(1))
                .batchUpdateSortFromTopToBottom(sort, targetSort);
        Mockito.verify(pageBlockRepository, Mockito.times(1))
                .updateSortById(blockId, targetSort);
    }

    @Test
    public void givenBlockIdAndSortAndTargetSort_whenSortEqualsTargetSort_thenDoNothing() {
        final int sort = 1;
        final int targetSort = 1;
        final Long blockId = 1L;
        pageBlockService.movePageBlock(blockId, sort, targetSort);
        Mockito.verify(pageBlockRepository, Mockito.times(0))
                .batchUpdateSortFromTopToBottom(sort, targetSort);
        Mockito.verify(pageBlockRepository, Mockito.times(0))
                .batchUpdateSortFromBottomToTop(targetSort, sort);
        Mockito.verify(pageBlockRepository, Mockito.times(0))
                .updateSortById(blockId, targetSort);
    }

    @Test
    public void givenBlockAndWaterfallBlockNotExist_whenAddBlockToLayout_thenBlockWillBeLast() {
        final Long id = 1L;
        final boolean hasWaterfall = false;
        final CreatePageBlockVM pageBlockVM = new CreatePageBlockVM(
                "Test Block",
                BlockConfig.builder()
                        .horizontalPadding(10.0)
                        .build(),
                BlockType.Banner,
                List.of(
                      new CreateOrUpdatePageBlockDataVM(
                              new ImageData(
                                      "http://localhost:8080/1.png",
                                      new ImageLink(ImageLinkType.Url, "http://localhost:8080/1/target"),
                                      "title 1"
                              )
                      ),
                        new CreateOrUpdatePageBlockDataVM(
                                new ImageData(
                                        "http://localhost:8080/2.png",
                                        new ImageLink(ImageLinkType.Url, "http://localhost:8080/2/target"),
                                        "title 2"
                                )
                        ),
                        new CreateOrUpdatePageBlockDataVM(
                                new ImageData(
                                        "http://localhost:8080/3.png",
                                        new ImageLink(ImageLinkType.Url, "http://localhost:8080/3/target"),
                                        "title 3"
                                )
                        )
                )
        );

        Mockito.when(pageLayoutService.getPageLayout(id)).thenReturn(pageLayout);
        Mockito.when(pageLayoutService.savePageLayout(ArgumentMatchers.any(PageLayout.class)))
                .thenAnswer(i -> i.getArguments()[0]);
        pageBlockService.addBlockToLayout(id, hasWaterfall, pageBlockVM);
        Mockito.verify(pageLayoutService, Mockito.times(1)).savePageLayout(ArgumentMatchers.any(PageLayout.class));
        assertEquals(4, pageLayout.getPageBlocks().size());
        assertEquals(1L, pageLayout.getPageBlocks().stream().findFirst().orElseThrow().getId());
        assertEquals(2L, pageLayout.getPageBlocks().stream().skip(1).findFirst().orElseThrow().getId());
        assertEquals(3L, pageLayout.getPageBlocks().stream().skip(2).findFirst().orElseThrow().getId());
        assertEquals(1, pageLayout.getPageBlocks().stream().filter(block -> block.getId().equals(1L)).findFirst().orElseThrow().getSort());
        assertEquals(2, pageLayout.getPageBlocks().stream().filter(block -> block.getId().equals(2L)).findFirst().orElseThrow().getSort());
        assertEquals(3, pageLayout.getPageBlocks().stream().filter(block -> block.getId().equals(3L)).findFirst().orElseThrow().getSort());
        assertEquals(4, pageLayout.getPageBlocks().stream().skip(3).findFirst().orElseThrow().getSort());
    }

    @Test
    public void givenBlockAndWaterfallBlockExists_whenAddBlockToLayout_thenBlockWillBeSecondLast() throws Exception {
        var waterfallBlock = PageBlock.builder()
                .id(4L)
                .sort(4)
                .title("Test Waterfall Block")
                .config(BlockConfig.builder().build())
                .type(BlockType.Waterfall)
                .build();
        pageLayout.addPageBlock(waterfallBlock);

        final Long id = 1L;
        final boolean hasWaterfall = true;
        final CreatePageBlockVM pageBlockVM = new CreatePageBlockVM(
                "Test Block",
                BlockConfig.builder()
                        .horizontalPadding(10.0)
                        .build(),
                BlockType.Banner,
                List.of(
                        new CreateOrUpdatePageBlockDataVM(
                                new ImageData(
                                        "http://localhost:8080/1.png",
                                        new ImageLink(ImageLinkType.Url, "http://localhost:8080/1/target"),
                                        "title 1"
                                )
                        ),
                        new CreateOrUpdatePageBlockDataVM(
                                new ImageData(
                                        "http://localhost:8080/2.png",
                                        new ImageLink(ImageLinkType.Url, "http://localhost:8080/2/target"),
                                        "title 2"
                                )
                        ),
                        new CreateOrUpdatePageBlockDataVM(
                                new ImageData(
                                        "http://localhost:8080/3.png",
                                        new ImageLink(ImageLinkType.Url, "http://localhost:8080/3/target"),
                                        "title 3"
                                )
                        )
                )
        );

        Mockito.when(pageLayoutService.getPageLayout(id)).thenReturn(pageLayout);
        Mockito.when(pageLayoutService.savePageLayout(ArgumentMatchers.any(PageLayout.class)))
                .thenAnswer(i -> i.getArguments()[0]);
        pageBlockService.addBlockToLayout(id, hasWaterfall, pageBlockVM);
        Mockito.verify(pageLayoutService, Mockito.times(1)).savePageLayout(ArgumentMatchers.any(PageLayout.class));
        final SortedSet<PageBlock> blocks = pageLayout.getPageBlocks();
        assertEquals(5, blocks.size());
        assertEquals(1L, blocks.stream().findFirst().orElseThrow().getId());
        assertEquals(2L, blocks.stream().skip(1).findFirst().orElseThrow().getId());
        assertEquals(3L, blocks.stream().skip(2).findFirst().orElseThrow().getId());
        assertNull(blocks.stream().skip(3).findFirst().orElseThrow().getId());
        assertEquals(4L, blocks.stream().skip(4).findFirst().orElseThrow().getId());
        assertEquals(1, blocks.stream().filter(block -> block.getId() != null && block.getId().equals(1L)).findFirst().orElseThrow().getSort());
        assertEquals(2, blocks.stream().filter(block -> block.getId() != null && block.getId().equals(2L)).findFirst().orElseThrow().getSort());
        assertEquals(3, blocks.stream().filter(block -> block.getId() != null && block.getId().equals(3L)).findFirst().orElseThrow().getSort());
        assertEquals(5, blocks.stream().filter(block -> block.getId() != null && block.getId().equals(4L)).findFirst().orElseThrow().getSort());
        assertEquals(4, blocks.stream().skip(3).findFirst().orElseThrow().getSort());
    }
}
