package com.mooc.backend.rest.admin;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.mooc.backend.entities.PageConfig;
import com.mooc.backend.entities.PageLayout;
import com.mooc.backend.enumerations.PageStatus;
import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;
import com.mooc.backend.errors.CustomException;
import com.mooc.backend.errors.ErrorType;
import com.mooc.backend.rest.vm.CreateOrUpdatePageLayoutVM;
import com.mooc.backend.rest.vm.PageLayoutAdminVM;
import com.mooc.backend.rest.vm.PageWrapper;
import com.mooc.backend.rest.vm.PublishPageLayoutVM;
import com.mooc.backend.services.PageLayoutService;
import com.mooc.backend.services.ValidationService;
import com.mooc.backend.specs.PageLayoutSpec;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentMatchers;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.result.MockMvcResultMatchers;

import java.time.LocalDateTime;
import java.util.Collections;

import static org.mockito.Mockito.when;

@WebMvcTest(PageLayoutAdminController.class)
@AutoConfigureMockMvc(addFilters = false)
class PageLayoutAdminControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private PageLayoutService pageLayoutService;

    @MockBean
    private ValidationService validationService;

    private ObjectMapper objectMapper;

    @BeforeEach
    void setUp() {
        objectMapper = new ObjectMapper();
        objectMapper.findAndRegisterModules();
    }

    @Test
    void givenQueryParams_whenGetPageLayouts_thenStatus200() throws Exception {
        PageConfig config = PageConfig.builder()
                .baselineScreenWidth(375.0)
                .build();
        PageLayout pageLayout = new PageLayout();
        pageLayout.setId(1L);
        pageLayout.setTitle("Test Page Layout");
        pageLayout.setPageType(PageType.Home);
        pageLayout.setPlatform(Platform.APP);
        pageLayout.setStatus(PageStatus.DRAFT);
        pageLayout.setConfig(config);

        PageLayoutAdminVM pageLayoutAdminVM = PageLayoutAdminVM.toVM(pageLayout);

        PageWrapper<PageLayoutAdminVM> pageWrapper = new PageWrapper<>(
                0,
                10,
                1,
                1,
                Collections.singletonList(pageLayoutAdminVM)
        );

        when(pageLayoutService.getPageLayouts(ArgumentMatchers.any(PageLayoutSpec.class), ArgumentMatchers.any(Pageable.class)))
                .thenReturn(new PageImpl<>(Collections.singletonList(pageLayout), Pageable.ofSize(10), 1));

        mockMvc.perform(MockMvcRequestBuilders.get("/api/v1/admin/layouts")
                        .param("pageType", "Home")
                        .param("platform", "APP")
                        .param("status", "DRAFT")
                        .param("page", "0")
                        .param("size", "10")
                        .param("sort", "id,desc")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(MockMvcResultMatchers.status().isOk())
                .andExpect(MockMvcResultMatchers.content().json(objectMapper.writeValueAsString(pageWrapper)));
    }

    @Test
    void givenId_whenGetPageLayout_thenStatus200() throws Exception {
        PageConfig config = PageConfig.builder()
                .baselineScreenWidth(375.0)
                .build();
        PageLayout pageLayout = new PageLayout();
        pageLayout.setId(1L);
        pageLayout.setTitle("Test Page Layout");
        pageLayout.setPageType(PageType.Home);
        pageLayout.setPlatform(Platform.APP);
        pageLayout.setStatus(PageStatus.DRAFT);
        pageLayout.setConfig(config);

        PageLayoutAdminVM pageLayoutDetailVM = PageLayoutAdminVM.toVM(pageLayout);

        when(pageLayoutService.getPageLayout(1L)).thenReturn(pageLayout);

        mockMvc.perform(MockMvcRequestBuilders.get("/api/v1/admin/layouts/1")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(MockMvcResultMatchers.status().isOk())
                .andExpect(MockMvcResultMatchers.content().json(objectMapper.writeValueAsString(pageLayoutDetailVM)));
    }

    @Test
    void givenCreateOrUpdatePageLayoutVM_whenAddPageLayout_thenStatus200() throws Exception {
        PageConfig config = PageConfig.builder()
                .baselineScreenWidth(375.0)
                .build();
        CreateOrUpdatePageLayoutVM createOrUpdatePageLayoutVM = new CreateOrUpdatePageLayoutVM(
                "Test Page Layout",
                config,
                PageType.Home,
                Platform.APP
        );

        PageLayout pageLayout = new PageLayout();
        pageLayout.setId(1L);
        pageLayout.setTitle("Test Page Layout");
        pageLayout.setPageType(PageType.Home);
        pageLayout.setPlatform(Platform.APP);
        pageLayout.setStatus(PageStatus.DRAFT);
        pageLayout.setConfig(config);

        PageLayoutAdminVM pageLayoutAdminVM = PageLayoutAdminVM.toVM(pageLayout);

        when(pageLayoutService.savePageLayout(ArgumentMatchers.any(PageLayout.class))).thenReturn(pageLayout);

        mockMvc.perform(MockMvcRequestBuilders.post("/api/v1/admin/layouts")
                        .content(objectMapper.writeValueAsString(createOrUpdatePageLayoutVM))
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(MockMvcResultMatchers.status().isOk())
                .andExpect(MockMvcResultMatchers.content().json(objectMapper.writeValueAsString(pageLayoutAdminVM)));
    }

    @Test
    void givenCreateOrUpdatePageLayoutVM_whenUpdatePageLayout_thenStatus200() throws Exception {
        PageConfig config = PageConfig.builder()
                .baselineScreenWidth(375.0)
                .build();

        CreateOrUpdatePageLayoutVM createOrUpdatePageLayoutVM = new CreateOrUpdatePageLayoutVM(
                "Test Page Layout",
                config,
                PageType.Home,
                Platform.APP
        );

        PageLayout pageLayout = new PageLayout();
        pageLayout.setId(1L);
        pageLayout.setTitle("Test Page Layout");
        pageLayout.setPageType(PageType.Home);
        pageLayout.setPlatform(Platform.APP);
        pageLayout.setStatus(PageStatus.DRAFT);
        pageLayout.setConfig(config);

        PageLayoutAdminVM pageLayoutAdminVM = PageLayoutAdminVM.toVM(pageLayout);

        when(pageLayoutService.getPageLayout(1L)).thenReturn(new PageLayout());
        when(pageLayoutService.savePageLayout(ArgumentMatchers.any(PageLayout.class))).thenReturn(pageLayout);

        mockMvc.perform(MockMvcRequestBuilders.put("/api/v1/admin/layouts/1")
                        .content(objectMapper.writeValueAsString(createOrUpdatePageLayoutVM))
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(MockMvcResultMatchers.status().isOk())
                .andExpect(MockMvcResultMatchers.content().json(objectMapper.writeValueAsString(pageLayoutAdminVM)));
    }

    @Test
    public void givenPageLayoutIsNotDraft_whenUpdatePageLayout_thenStatus500() throws Exception {
        PageConfig config = PageConfig.builder()
                .baselineScreenWidth(375.0)
                .build();

        CreateOrUpdatePageLayoutVM createOrUpdatePageLayoutVM = new CreateOrUpdatePageLayoutVM(
                "Test Page Layout",
                config,
                PageType.Home,
                Platform.APP
        );

        PageLayout pageLayout = new PageLayout();
        pageLayout.setId(1L);
        pageLayout.setTitle("Test Page Layout");
        pageLayout.setPageType(PageType.Home);
        pageLayout.setPlatform(Platform.APP);
        pageLayout.setStatus(PageStatus.PUBLISHED);
        pageLayout.setConfig(config);

        when(pageLayoutService.getPageLayout(1L)).thenReturn(pageLayout);

        mockMvc.perform(MockMvcRequestBuilders.put("/api/v1/admin/layouts/1")
                        .content(objectMapper.writeValueAsString(createOrUpdatePageLayoutVM))
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(MockMvcResultMatchers.status().is5xxServerError());
    }

    @Test
    void givenId_whenPublishPageLayout_thenStatus200() throws Exception {
        PageConfig config = PageConfig.builder()
                .baselineScreenWidth(375.0)
                .build();
        var startTime = LocalDateTime.now();
        var endTime = LocalDateTime.now().plusDays(1);
        PublishPageLayoutVM publishPageLayoutVM = new PublishPageLayoutVM(
                startTime,
                endTime
        );

        PageLayout oldPageLayout = new PageLayout();
        oldPageLayout.setId(1L);
        oldPageLayout.setTitle("Test Page Layout");
        oldPageLayout.setPageType(PageType.Home);
        oldPageLayout.setPlatform(Platform.APP);
        oldPageLayout.setStatus(PageStatus.DRAFT);
        oldPageLayout.setConfig(config);

        PageLayout pageLayout = new PageLayout();
        pageLayout.setId(1L);
        pageLayout.setTitle("Test Page Layout");
        pageLayout.setPageType(PageType.Home);
        pageLayout.setPlatform(Platform.APP);
        pageLayout.setStatus(PageStatus.PUBLISHED);
        pageLayout.setConfig(config);

        PageLayoutAdminVM pageLayoutAdminVM = PageLayoutAdminVM.toVM(pageLayout);

        when(pageLayoutService.getPageLayout(1L)).thenReturn(oldPageLayout);
        when(pageLayoutService.savePageLayout(ArgumentMatchers.any(PageLayout.class))).thenReturn(pageLayout);

        mockMvc.perform(MockMvcRequestBuilders.patch("/api/v1/admin/layouts/1/status/publish")
                        .content(objectMapper.writeValueAsString(publishPageLayoutVM))
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(MockMvcResultMatchers.status().isOk())
                .andExpect(MockMvcResultMatchers.content().json(objectMapper.writeValueAsString(pageLayoutAdminVM)));
    }

    @Test
    public void givenTimeConflict_whenPublishPageLayout_thenStatus500() throws Exception {
        PageConfig config = PageConfig.builder()
                .baselineScreenWidth(375.0)
                .build();
        var startTime = LocalDateTime.now();
        var endTime = LocalDateTime.now().plusDays(1);
        PublishPageLayoutVM publishPageLayoutVM = new PublishPageLayoutVM(
                startTime,
                endTime
        );

        PageLayout oldPageLayout = new PageLayout();
        oldPageLayout.setId(1L);
        oldPageLayout.setTitle("Test Page Layout");
        oldPageLayout.setPageType(PageType.Home);
        oldPageLayout.setPlatform(Platform.APP);
        oldPageLayout.setStatus(PageStatus.DRAFT);
        oldPageLayout.setConfig(config);

        PageLayout pageLayout = new PageLayout();
        pageLayout.setId(1L);
        pageLayout.setTitle("Test Page Layout");
        pageLayout.setPageType(PageType.Home);
        pageLayout.setPlatform(Platform.APP);
        pageLayout.setStatus(PageStatus.PUBLISHED);
        pageLayout.setConfig(config);

        Mockito.doThrow(new CustomException("发布时间冲突", "PublishTimeConflict", ErrorType.ConstraintViolationException))
                .when(validationService)
                .checkPublishTimeConflict(
                    publishPageLayoutVM.startTime(),
                    oldPageLayout.getPlatform(),
                    oldPageLayout.getPageType()
                );
        when(pageLayoutService.getPageLayout(1L)).thenReturn(oldPageLayout);
        when(pageLayoutService.savePageLayout(ArgumentMatchers.any(PageLayout.class))).thenReturn(pageLayout);

        mockMvc.perform(MockMvcRequestBuilders.patch("/api/v1/admin/layouts/1/status/publish")
                        .content(objectMapper.writeValueAsString(publishPageLayoutVM))
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(MockMvcResultMatchers.status().is5xxServerError());
    }

    @Test
    void givenId_whenDraftPageLayout_thenStatus200() throws Exception {
        PageConfig config = PageConfig.builder()
                .baselineScreenWidth(375.0)
                .build();

        PageLayout oldPageLayout = new PageLayout();
        oldPageLayout.setId(1L);
        oldPageLayout.setTitle("Test Page Layout");
        oldPageLayout.setPageType(PageType.Home);
        oldPageLayout.setPlatform(Platform.APP);
        oldPageLayout.setStatus(PageStatus.PUBLISHED);
        oldPageLayout.setConfig(config);

        PageLayout pageLayout = new PageLayout();
        pageLayout.setId(1L);
        pageLayout.setTitle("Test Page Layout");
        pageLayout.setPageType(PageType.Home);
        pageLayout.setPlatform(Platform.APP);
        pageLayout.setStatus(PageStatus.DRAFT);
        pageLayout.setConfig(config);

        PageLayoutAdminVM pageLayoutAdminVM = PageLayoutAdminVM.toVM(pageLayout);

        when(pageLayoutService.getPageLayout(1L)).thenReturn(oldPageLayout);
        when(pageLayoutService.savePageLayout(ArgumentMatchers.any(PageLayout.class))).thenReturn(pageLayout);

        mockMvc.perform(MockMvcRequestBuilders.patch("/api/v1/admin/layouts/1/status/draft")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(MockMvcResultMatchers.status().isOk())
                .andExpect(MockMvcResultMatchers.content().json(objectMapper.writeValueAsString(pageLayoutAdminVM)));
    }

    @Test
    void givenId_whenDeletePageLayout_thenStatus200() throws Exception {
        mockMvc.perform(MockMvcRequestBuilders.delete("/api/v1/admin/layouts/1")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(MockMvcResultMatchers.status().isOk());
    }
}