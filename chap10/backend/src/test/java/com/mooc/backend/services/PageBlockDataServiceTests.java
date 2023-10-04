package com.mooc.backend.services;

import com.mooc.backend.entities.*;
import com.mooc.backend.enumerations.BlockType;
import com.mooc.backend.enumerations.ImageLinkType;
import com.mooc.backend.repositories.PageBlockDataRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentMatchers;
import org.mockito.Mockito;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.test.context.junit.jupiter.SpringExtension;

import static org.junit.jupiter.api.Assertions.assertEquals;

@ExtendWith(SpringExtension.class)
public class PageBlockDataServiceTests {

    @MockBean
    private PageBlockDataRepository pageBlockDataRepository;

    @MockBean
    private PageBlockService pageBlockService;

    private PageBlockDataService pageBlockDataService;

    private PageBlock bannerBlock;

    @BeforeEach
    public void setUp() {
        pageBlockDataService = new PageBlockDataService(pageBlockDataRepository, pageBlockService);
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
        var bannerContent3 = new ImageData(
                "http://localhost:8080/3.png",
                new ImageLink(ImageLinkType.Url, "http://localhost:8080/3/target"),
                "title 3"
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

        var bannerData3 = PageBlockData.builder()
                .id(3L)
                .sort(3)
                .content(bannerContent3)
                .build();

        bannerBlock = PageBlock.builder()
                .id(1L)
                .sort(1)
                .title("Test Banner Block")
                .config(blockConfig)
                .type(BlockType.Banner)
                .build();
        bannerBlock.addData(bannerData1);
        bannerBlock.addData(bannerData2);
        bannerBlock.addData(bannerData3);
    }

    @Test
    public void givenPageBlockDataId_whenDelete_thenDeleteIsOk() {
        Mockito.when(pageBlockService.getPageBlock(bannerBlock.getId())).thenReturn(bannerBlock);
        Mockito.when(pageBlockService.savePageBlock(ArgumentMatchers.any(PageBlock.class)))
                .thenAnswer(i -> i.getArguments()[0]);

        var pageBlock = pageBlockDataService.deletePageBlockData(bannerBlock.getId(), 1L);
        Mockito.verify(pageBlockService, Mockito.times(1)).savePageBlock(pageBlock);
        assertEquals(2, pageBlock.getData().size());
        assertEquals(2L, pageBlock.getData().stream().findFirst().orElseThrow().getId());
        assertEquals(1, pageBlock.getData().stream().findFirst().orElseThrow().getSort());
        assertEquals(3L, pageBlock.getData().stream().skip(1).findFirst().orElseThrow().getId());
        assertEquals(2, pageBlock.getData().stream().skip(1).findFirst().orElseThrow().getSort());
    }

    @Test
    public void givenPageBlockDataIdAndTargetPageBlockDataId_whenMoveAsc_thenMoveIsOk() {
        final Long dataId = 1L;
        final Long targetDataId = 3L;
        Mockito.when(pageBlockService.getPageBlock(bannerBlock.getId())).thenReturn(bannerBlock);
        Mockito.when(pageBlockService.savePageBlock(ArgumentMatchers.any(PageBlock.class)))
                .thenAnswer(i -> i.getArguments()[0]);

        pageBlockDataService.movePageBlockData(bannerBlock.getId(), dataId, targetDataId);
        Mockito.verify(pageBlockService, Mockito.times(1)).savePageBlock(bannerBlock);
        assertEquals(3, bannerBlock.getData().size());
        assertEquals(1L, bannerBlock.getData().stream().findFirst().orElseThrow().getId());
        assertEquals(3, bannerBlock.getData().stream().findFirst().orElseThrow().getSort());
        assertEquals(2L, bannerBlock.getData().stream().skip(1).findFirst().orElseThrow().getId());
        assertEquals(1, bannerBlock.getData().stream().skip(1).findFirst().orElseThrow().getSort());
        assertEquals(3L, bannerBlock.getData().stream().skip(2).findFirst().orElseThrow().getId());
        assertEquals(2, bannerBlock.getData().stream().skip(2).findFirst().orElseThrow().getSort());
    }

    @Test
    public void givenPageBlockDataIdAndTargetPageBlockDataId_whenMoveDesc_thenMoveIsOk() {
        final Long dataId = 3L;
        final Long targetDataId = 1L;
        Mockito.when(pageBlockService.getPageBlock(bannerBlock.getId())).thenReturn(bannerBlock);
        Mockito.when(pageBlockService.savePageBlock(ArgumentMatchers.any(PageBlock.class)))
                .thenAnswer(i -> i.getArguments()[0]);

        pageBlockDataService.movePageBlockData(bannerBlock.getId(), dataId, targetDataId);
        Mockito.verify(pageBlockService, Mockito.times(1)).savePageBlock(bannerBlock);
        assertEquals(3, bannerBlock.getData().size());
        assertEquals(1L, bannerBlock.getData().stream().findFirst().orElseThrow().getId());
        assertEquals(2, bannerBlock.getData().stream().findFirst().orElseThrow().getSort());
        assertEquals(2L, bannerBlock.getData().stream().skip(1).findFirst().orElseThrow().getId());
        assertEquals(3, bannerBlock.getData().stream().skip(1).findFirst().orElseThrow().getSort());
        assertEquals(3L, bannerBlock.getData().stream().skip(2).findFirst().orElseThrow().getId());
        assertEquals(1, bannerBlock.getData().stream().skip(2).findFirst().orElseThrow().getSort());
    }

    @Test
    public void givenPageBlockDataIdAndTargetPageBlockDataId_whenMoveToSamePosition_thenDoNothing() {
        final Long dataId = 1L;
        final Long targetDataId = 1L;
        Mockito.when(pageBlockService.getPageBlock(bannerBlock.getId())).thenReturn(bannerBlock);
        Mockito.when(pageBlockService.savePageBlock(ArgumentMatchers.any(PageBlock.class)))
                .thenAnswer(i -> i.getArguments()[0]);

        pageBlockDataService.movePageBlockData(bannerBlock.getId(), dataId, targetDataId);
        Mockito.verify(pageBlockService, Mockito.times(0)).savePageBlock(bannerBlock);
        assertEquals(3, bannerBlock.getData().size());
        assertEquals(1L, bannerBlock.getData().stream().findFirst().orElseThrow().getId());
        assertEquals(1, bannerBlock.getData().stream().findFirst().orElseThrow().getSort());
        assertEquals(2L, bannerBlock.getData().stream().skip(1).findFirst().orElseThrow().getId());
        assertEquals(2, bannerBlock.getData().stream().skip(1).findFirst().orElseThrow().getSort());
        assertEquals(3L, bannerBlock.getData().stream().skip(2).findFirst().orElseThrow().getId());
        assertEquals(3, bannerBlock.getData().stream().skip(2).findFirst().orElseThrow().getSort());
    }
}
