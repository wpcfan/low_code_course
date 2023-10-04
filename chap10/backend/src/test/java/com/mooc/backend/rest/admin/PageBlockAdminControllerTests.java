package com.mooc.backend.rest.admin;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.mooc.backend.entities.*;
import com.mooc.backend.enumerations.*;
import com.mooc.backend.errors.CustomException;
import com.mooc.backend.errors.ErrorType;
import com.mooc.backend.rest.vm.CreateOrUpdatePageBlockDataVM;
import com.mooc.backend.rest.vm.CreatePageBlockVM;
import com.mooc.backend.rest.vm.UpdatePageBlockVM;
import com.mooc.backend.services.PageBlockService;
import com.mooc.backend.services.PageLayoutService;
import com.mooc.backend.services.ValidationService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentMatchers;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.result.MockMvcResultMatchers;

import java.util.Collections;

@WebMvcTest(PageBlockAdminController.class)
@AutoConfigureMockMvc(addFilters = false)
public class PageBlockAdminControllerTests {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private PageLayoutService pageLayoutService;

    @MockBean
    private PageBlockService pageBlockService;

    @MockBean
    private ValidationService validationService;

    private ObjectMapper objectMapper;

    @BeforeEach
    void setUp() {
        objectMapper = new ObjectMapper();
        objectMapper.findAndRegisterModules();
    }

    @Test
    public void givenCreatePageBlockVM_whenAddPageBlock_thenStatus200() throws Exception {
        var config = BlockConfig.builder()
                .horizontalSpacing(12.0)
                .verticalSpacing(12.0)
                .horizontalPadding(16.0)
                .verticalPadding(16.0)
                .build();
        var imageData1 = new ImageData(
                "http://qiniu.com/1.jpg",
                new ImageLink(
                        ImageLinkType.Url,
                        "http://example.com"
                ),
                "alt1"
        );
        var pageBlockData = PageBlockData.builder()
                .content(imageData1)
                .sort(1)
                .build();
        var pageBlock = com.mooc.backend.entities.PageBlock.builder()
                .title("Page Block Title")
                .config(config)
                .type(BlockType.Banner)
                .build();
        pageBlock.addData(pageBlockData);
        var data1 = new CreateOrUpdatePageBlockDataVM(imageData1);
        var pageBlockVM = new CreatePageBlockVM(
                "Page Block Title",
                config,
                BlockType.Banner,
                Collections.singletonList(data1)
        );

        Mockito.doNothing()
                .when(validationService)
                .checkPageStatusIsDraft(ArgumentMatchers.anyLong());
        Mockito.when(pageBlockService.countByTypeAndPageLayoutId(
                ArgumentMatchers.any(BlockType.class),
                ArgumentMatchers.anyLong()))
                .thenReturn(1L);
        Mockito.when(pageBlockService.addBlockToLayout(
                ArgumentMatchers.anyLong(),
                ArgumentMatchers.anyBoolean(),
                ArgumentMatchers.any(CreatePageBlockVM.class)))
                .thenReturn(pageBlock);

        mockMvc.perform(MockMvcRequestBuilders.post(
                "/api/v1/admin/layouts/1/blocks")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(pageBlockVM)))
                .andExpect(MockMvcResultMatchers.status().isOk());
    }

    @Test
    public void givenCreatePageBlockVM_whenAddPageBlockAndPageLayoutIsNotDraft_thenStatus500() throws Exception {
        var config = BlockConfig.builder()
                .horizontalSpacing(12.0)
                .verticalSpacing(12.0)
                .horizontalPadding(16.0)
                .verticalPadding(16.0)
                .build();
        var imageData1 = new ImageData(
                "http://qiniu.com/1.jpg",
                new ImageLink(
                        ImageLinkType.Url,
                        "http://example.com"
                ),
                "alt1"
        );
        var pageBlockData = PageBlockData.builder()
                .content(imageData1)
                .sort(1)
                .build();
        var pageBlock = com.mooc.backend.entities.PageBlock.builder()
                .title("Page Block Title")
                .config(config)
                .type(BlockType.Banner)
                .build();
        pageBlock.addData(pageBlockData);
        var data1 = new CreateOrUpdatePageBlockDataVM(imageData1);
        var pageBlockVM = new CreatePageBlockVM(
                "Page Block Title",
                config,
                BlockType.Banner,
                Collections.singletonList(data1));

        Mockito.doThrow(new CustomException(
                        "页面不是草稿状态",
                        "PageNotDraft",
                        ErrorType.ConstraintViolationException))
                .when(validationService)
                .checkPageStatusIsDraft(ArgumentMatchers.anyLong());
        Mockito.when(pageBlockService.addBlockToLayout(
                ArgumentMatchers.anyLong(),
                ArgumentMatchers.anyBoolean(),
                ArgumentMatchers.any(CreatePageBlockVM.class)))
                .thenReturn(pageBlock);

        mockMvc.perform(MockMvcRequestBuilders.post(
                "/api/v1/admin/layouts/1/blocks")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(pageBlockVM)))
                .andExpect(MockMvcResultMatchers.status().is5xxServerError());
    }

    @Test
    public void givenWaterfallBlock_whenAddPageBlockAndWaterfallBlockExisted_thenStatus500() throws Exception {
        var config = BlockConfig.builder()
                .horizontalSpacing(12.0)
                .verticalSpacing(12.0)
                .horizontalPadding(16.0)
                .verticalPadding(16.0)
                .build();
        var categoryData = new CategoryData(
                1L,
                "Category Subtitle",
                "cat_1",
                Collections.emptyList()
        );
        var pageBlockData = PageBlockData.builder()
                .content(categoryData)
                .sort(1)
                .build();
        var pageBlock = com.mooc.backend.entities.PageBlock.builder()
                .title("Page Block Title")
                .config(config)
                .type(BlockType.Waterfall)
                .build();
        pageBlock.addData(pageBlockData);
        var data1 = new CreateOrUpdatePageBlockDataVM(categoryData);
        var pageBlockVM = new CreatePageBlockVM(
                "Page Block Title",
                config,
                BlockType.Waterfall,
                Collections.singletonList(data1));

        Mockito.doNothing()
                .when(validationService)
                .checkPageStatusIsDraft(ArgumentMatchers.anyLong());
        Mockito.when(pageBlockService.countByTypeAndPageLayoutId(
                ArgumentMatchers.any(BlockType.class),
                ArgumentMatchers.anyLong()))
                .thenReturn(1L);
        Mockito.when(pageBlockService.addBlockToLayout(
                ArgumentMatchers.anyLong(),
                ArgumentMatchers.anyBoolean(),
                ArgumentMatchers.any(CreatePageBlockVM.class)))
                .thenReturn(pageBlock);

        mockMvc.perform(MockMvcRequestBuilders.post(
                "/api/v1/admin/layouts/1/blocks")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(pageBlockVM)))
                .andExpect(MockMvcResultMatchers.status().is5xxServerError());
    }

    @Test
    public void givenWaterfallBlock_whenAddPageBlockAndWaterfallBlockNotExisted_thenStatus200() throws Exception {
        var config = BlockConfig.builder()
                .horizontalSpacing(12.0)
                .verticalSpacing(12.0)
                .horizontalPadding(16.0)
                .verticalPadding(16.0)
                .build();
        var categoryData = new CategoryData(
                1L,
                "Category Subtitle",
                "cat_1",
                Collections.emptyList()
        );
        var pageBlockData = PageBlockData.builder()
                .content(categoryData)
                .sort(1)
                .build();
        var pageBlock = com.mooc.backend.entities.PageBlock.builder()
                .title("Page Block Title")
                .config(config)
                .type(BlockType.Waterfall)
                .build();
        pageBlock.addData(pageBlockData);
        var data1 = new CreateOrUpdatePageBlockDataVM(categoryData);
        var pageBlockVM = new CreatePageBlockVM(
                "Page Block Title",
                config,
                BlockType.Waterfall,
                Collections.singletonList(data1));

        Mockito.doNothing()
                .when(validationService)
                .checkPageStatusIsDraft(ArgumentMatchers.anyLong());
        Mockito.when(pageBlockService.countByTypeAndPageLayoutId(
                ArgumentMatchers.any(BlockType.class),
                ArgumentMatchers.anyLong()))
                .thenReturn(0L);
        Mockito.when(pageBlockService.addBlockToLayout(
                ArgumentMatchers.anyLong(),
                ArgumentMatchers.anyBoolean(),
                ArgumentMatchers.any(CreatePageBlockVM.class)))
                .thenReturn(pageBlock);

        mockMvc.perform(MockMvcRequestBuilders.post(
                "/api/v1/admin/layouts/1/blocks")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(pageBlockVM)))
                .andExpect(MockMvcResultMatchers.status().isOk());
    }

    @Test
    public void givenUpdatePageBlockVM_whenUpdatePageBlock_thenStatus200() throws Exception {
        var config = BlockConfig.builder()
                .horizontalSpacing(12.0)
                .verticalSpacing(12.0)
                .horizontalPadding(16.0)
                .verticalPadding(16.0)
                .build();

        var pageBlock = com.mooc.backend.entities.PageBlock.builder()
                .title("Page Block Title")
                .config(config)
                .type(BlockType.Banner)
                .build();

        var updatePageBlockVM = new UpdatePageBlockVM(
                "Page Block Title",
                config);

        Mockito.doNothing()
                .when(validationService)
                .checkPageStatusIsDraft(ArgumentMatchers.anyLong());
        Mockito.doNothing()
                .when(validationService)
                .checkPageBlockNotExist(ArgumentMatchers.anyLong(), ArgumentMatchers.anyLong());
        Mockito.when(pageBlockService.getPageBlock(ArgumentMatchers.anyLong()))
                .thenReturn(pageBlock);
        Mockito.when(pageBlockService.savePageBlock(ArgumentMatchers.any(PageBlock.class)))
                .thenReturn(pageBlock);

        mockMvc.perform(MockMvcRequestBuilders.put(
                "/api/v1/admin/layouts/1/blocks/1")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(updatePageBlockVM)))
                .andExpect(MockMvcResultMatchers.status().isOk());
    }

    @Test
    public void givenTwoPageBlocks_whenMovePageBlock_thenStatus200() throws Exception {
        var config = BlockConfig.builder()
                .horizontalSpacing(12.0)
                .verticalSpacing(12.0)
                .horizontalPadding(16.0)
                .verticalPadding(16.0)
                .build();

        var pageBlock1 = com.mooc.backend.entities.PageBlock.builder()
                .id(1L)
                .title("Page Block Title")
                .config(config)
                .type(BlockType.Banner)
                .sort(1)
                .build();

        var pageBlock2 = com.mooc.backend.entities.PageBlock.builder()
                .id(2L)
                .title("Page Block Title")
                .config(config)
                .type(BlockType.Banner)
                .sort(2)
                .build();
        var pageConfig = new PageConfig();
        pageConfig.setBaselineScreenWidth(375.0);
        var pageLayout = new PageLayout();
        pageLayout.setId(1L);
        pageLayout.setTitle("Page Layout Title");
        pageLayout.setPlatform(Platform.APP);
        pageLayout.setPageType(PageType.Home);
        pageLayout.setStatus(PageStatus.DRAFT);
        pageLayout.setConfig(pageConfig);
        pageLayout.addPageBlock(pageBlock1);
        pageLayout.addPageBlock(pageBlock2);
        Mockito.doNothing()
                .when(validationService)
                .checkPageStatusIsDraft(
                        ArgumentMatchers.anyLong());
        Mockito.doNothing()
                .when(validationService)
                .checkPageBlockNotExist(
                        ArgumentMatchers.anyLong(),
                        ArgumentMatchers.anyLong());
        Mockito.doNothing()
                .when(validationService)
                .checkWaterfallBlockCannotMove(
                        ArgumentMatchers.anyLong(),
                        ArgumentMatchers.anyLong());

        Mockito.when(pageLayoutService.getPageLayout(
                ArgumentMatchers.anyLong()
                ))
                .thenReturn(pageLayout);
        Mockito.doNothing()
                .when(pageBlockService)
                .movePageBlock(
                        ArgumentMatchers.anyLong(),
                        ArgumentMatchers.anyInt(),
                        ArgumentMatchers.anyInt());

        mockMvc.perform(MockMvcRequestBuilders.put(
                "/api/v1/admin/layouts/1/blocks/1/sort/2"))
                .andExpect(MockMvcResultMatchers.status().isOk());
    }

    @Test
    public void givenTwoPageBlocks_whenMovePageBlockAndPageLayoutIsNotDraft_thenStatus500() throws Exception {
        var config = BlockConfig.builder()
                .horizontalSpacing(12.0)
                .verticalSpacing(12.0)
                .horizontalPadding(16.0)
                .verticalPadding(16.0)
                .build();

        var pageBlock1 = com.mooc.backend.entities.PageBlock.builder()
                .id(1L)
                .title("Page Block Title")
                .config(config)
                .type(BlockType.Banner)
                .sort(1)
                .build();

        var pageBlock2 = com.mooc.backend.entities.PageBlock.builder()
                .id(2L)
                .title("Page Block Title")
                .config(config)
                .type(BlockType.Banner)
                .sort(2)
                .build();
        var pageConfig = new PageConfig();
        pageConfig.setBaselineScreenWidth(375.0);
        var pageLayout = new PageLayout();
        pageLayout.setId(1L);
        pageLayout.setTitle("Page Layout Title");
        pageLayout.setPlatform(Platform.APP);
        pageLayout.setPageType(PageType.Home);
        pageLayout.setStatus(PageStatus.PUBLISHED);
        pageLayout.setConfig(pageConfig);
        pageLayout.addPageBlock(pageBlock1);
        pageLayout.addPageBlock(pageBlock2);
        Mockito.doThrow(new CustomException(
                        "页面不是草稿状态",
                        "PageNotDraft",
                        ErrorType.ConstraintViolationException))
                .when(validationService)
                .checkPageStatusIsDraft(
                        ArgumentMatchers.anyLong());
        Mockito.doNothing()
                .when(validationService)
                .checkPageBlockNotExist(
                        ArgumentMatchers.anyLong(),
                        ArgumentMatchers.anyLong());
        Mockito.doNothing()
                .when(validationService)
                .checkWaterfallBlockCannotMove(
                        ArgumentMatchers.anyLong(),
                        ArgumentMatchers.anyLong());

        Mockito.when(pageLayoutService.getPageLayout(
                ArgumentMatchers.anyLong()
                ))
                .thenReturn(pageLayout);
        Mockito.doNothing()
                .when(pageBlockService)
                .movePageBlock(
                        ArgumentMatchers.anyLong(),
                        ArgumentMatchers.anyInt(),
                        ArgumentMatchers.anyInt());

        mockMvc.perform(MockMvcRequestBuilders.put(
                "/api/v1/admin/layouts/1/blocks/1/sort/2"))
                .andExpect(MockMvcResultMatchers.status().is5xxServerError());
    }

    @Test
    public void givenTwoPageBlocks_whenMovePageBlockAndPageBlockNotExist_thenStatus500() throws Exception {
        var config = BlockConfig.builder()
                .horizontalSpacing(12.0)
                .verticalSpacing(12.0)
                .horizontalPadding(16.0)
                .verticalPadding(16.0)
                .build();

        var pageBlock1 = com.mooc.backend.entities.PageBlock.builder()
                .id(1L)
                .title("Page Block Title")
                .config(config)
                .type(BlockType.Banner)
                .sort(1)
                .build();

        var pageBlock2 = com.mooc.backend.entities.PageBlock.builder()
                .id(2L)
                .title("Page Block Title")
                .config(config)
                .type(BlockType.Banner)
                .sort(2)
                .build();
        var pageConfig = new PageConfig();
        pageConfig.setBaselineScreenWidth(375.0);
        var pageLayout = new PageLayout();
        pageLayout.setId(1L);
        pageLayout.setTitle("Page Layout Title");
        pageLayout.setPlatform(Platform.APP);
        pageLayout.setPageType(PageType.Home);
        pageLayout.setStatus(PageStatus.DRAFT);
        pageLayout.setConfig(pageConfig);
        pageLayout.addPageBlock(pageBlock1);
        pageLayout.addPageBlock(pageBlock2);
        Mockito.doNothing()
                .when(validationService)
                .checkPageStatusIsDraft(
                        ArgumentMatchers.anyLong());
        Mockito.doThrow(new CustomException(
                        "页面区块不存在",
                        "PageBlockNotFound",
                        ErrorType.ResourcesNotFoundException))
                .when(validationService)
                .checkPageBlockNotExist(
                        ArgumentMatchers.anyLong(),
                        ArgumentMatchers.anyLong());
        Mockito.doNothing()
                .when(validationService)
                .checkWaterfallBlockCannotMove(
                        ArgumentMatchers.anyLong(),
                        ArgumentMatchers.anyLong());

        Mockito.when(pageLayoutService.getPageLayout(
                ArgumentMatchers.anyLong()
                ))
                .thenReturn(pageLayout);
        Mockito.doNothing()
                .when(pageBlockService)
                .movePageBlock(
                        ArgumentMatchers.anyLong(),
                        ArgumentMatchers.anyInt(),
                        ArgumentMatchers.anyInt());

        mockMvc.perform(MockMvcRequestBuilders.put(
                "/api/v1/admin/layouts/1/blocks/1/sort/2"))
                .andExpect(MockMvcResultMatchers.status().is5xxServerError());
    }

    @Test
    public void givenTwoPageBlocks_whenMovePageBlockAndWaterfallBlockCannotMove_thenStatus500() throws Exception {
        var config = BlockConfig.builder()
                .horizontalSpacing(12.0)
                .verticalSpacing(12.0)
                .horizontalPadding(16.0)
                .verticalPadding(16.0)
                .build();

        var pageBlock1 = com.mooc.backend.entities.PageBlock.builder()
                .id(1L)
                .title("Page Block Title")
                .config(config)
                .type(BlockType.Banner)
                .sort(1)
                .build();

        var pageBlock2 = com.mooc.backend.entities.PageBlock.builder()
                .id(2L)
                .title("Page Block Title")
                .config(config)
                .type(BlockType.Banner)
                .sort(2)
                .build();
        var pageConfig = new PageConfig();
        pageConfig.setBaselineScreenWidth(375.0);
        var pageLayout = new PageLayout();
        pageLayout.setId(1L);
        pageLayout.setTitle("Page Layout Title");
        pageLayout.setPlatform(Platform.APP);
        pageLayout.setPageType(PageType.Home);
        pageLayout.setStatus(PageStatus.DRAFT);
        pageLayout.setConfig(pageConfig);
        pageLayout.addPageBlock(pageBlock1);
        pageLayout.addPageBlock(pageBlock2);
        Mockito.doNothing()
                .when(validationService)
                .checkPageStatusIsDraft(
                        ArgumentMatchers.anyLong());
        Mockito.doNothing()
                .when(validationService)
                .checkPageBlockNotExist(
                        ArgumentMatchers.anyLong(),
                        ArgumentMatchers.anyLong());
        Mockito.doThrow(new CustomException(
                        "瀑布流区块不能移动",
                        "WaterfallBlockCannotMove",
                        ErrorType.ConstraintViolationException))
                .when(validationService)
                .checkWaterfallBlockCannotMove(
                        ArgumentMatchers.anyLong(),
                        ArgumentMatchers.anyLong());

        Mockito.when(pageLayoutService.getPageLayout(
                        ArgumentMatchers.anyLong()
                ))
                .thenReturn(pageLayout);
        Mockito.doNothing()
                .when(pageBlockService)
                .movePageBlock(
                        ArgumentMatchers.anyLong(),
                        ArgumentMatchers.anyInt(),
                        ArgumentMatchers.anyInt());

        mockMvc.perform(MockMvcRequestBuilders.put(
                        "/api/v1/admin/layouts/1/blocks/1/sort/2"))
                .andExpect(MockMvcResultMatchers.status().is5xxServerError());
    }
}
