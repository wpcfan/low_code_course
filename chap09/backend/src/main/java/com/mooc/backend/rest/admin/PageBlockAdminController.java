package com.mooc.backend.rest.admin;

import com.mooc.backend.entities.PageBlock;
import com.mooc.backend.entities.PageBlockData;
import com.mooc.backend.entities.PageLayout;
import com.mooc.backend.errors.CustomException;
import com.mooc.backend.errors.ErrorType;
import com.mooc.backend.rest.vm.CreatePageBlockVM;
import com.mooc.backend.rest.vm.UpdatePageBlockVM;
import com.mooc.backend.services.PageBlockService;
import com.mooc.backend.services.PageLayoutService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import io.swagger.v3.oas.annotations.tags.Tags;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

@Tags({
        @Tag(name = "页面布局管理", description = "页面布局管理相关接口"),
        @Tag(name = "页面区块管理", description = "页面区块管理相关接口"),
})
@Validated
@RestController
@RequestMapping("/api/v1/admin/layouts")
@RequiredArgsConstructor
public class PageBlockAdminController {
    private final PageLayoutService pageLayoutService;
    private final PageBlockService pageBlockService;

    @Operation(summary = "添加页面区块")
    @PostMapping("/{id}/blocks")
    public PageBlock addPageBlock(@PathVariable Long id, @RequestBody @Valid CreatePageBlockVM pageBlockVM) {
        PageLayout pageLayout = pageLayoutService.getPageLayout(id);
        PageBlock pageBlock = new PageBlock();
        pageBlock.setTitle(pageBlockVM.title());
        pageBlock.setSort(pageLayout.getPageBlocks().size() + 1);
        pageBlock.setConfig(pageBlockVM.config());
        pageBlock.setType(pageBlockVM.type());
        pageBlockVM.data().forEach(dataVM -> {
            PageBlockData pageBlockData = new PageBlockData();
            pageBlockData.setContent(dataVM.content());
            pageBlockData.setSort(pageBlock.getData().size() + 1);
            pageBlock.addData(pageBlockData);
        });
        pageBlock.setPageLayout(pageLayout);
        return pageBlockService.savePageBlock(pageBlock);
    }

    @Operation(summary = "更新页面区块")
    @PutMapping("/{id}/blocks/{blockId}")
    public PageBlock updatePageBlock(@PathVariable Long id, @PathVariable Long blockId, @RequestBody @Valid UpdatePageBlockVM pageBlockVM) {
        PageLayout pageLayout = pageLayoutService.getPageLayout(id);
        if (pageLayout.getPageBlocks().stream().noneMatch(pageBlock -> pageBlock.getId().equals(blockId))) {
            throw new CustomException("页面区块不存在", "PageBlockNotFound", ErrorType.ResourcesNotFoundException);
        }
        PageBlock pageBlock = pageBlockService.getPageBlock(blockId);
        pageBlock.setTitle(pageBlockVM.title());
        pageBlock.setConfig(pageBlockVM.config());
        return pageBlockService.savePageBlock(pageBlock);
    }

    @Operation(summary = "移动页面区块")
    @PutMapping("/{id}/blocks/{blockId}/sort/{targetBlockId}")
    public void movePageBlock(@PathVariable Long id, @PathVariable Long blockId, @PathVariable Long targetBlockId) {
        PageLayout pageLayout = pageLayoutService.getPageLayout(id);
        if (pageLayout.getPageBlocks().stream().noneMatch(pageBlock -> pageBlock.getId().equals(blockId))) {
            throw new CustomException("页面区块不存在", "PageBlockNotFound", ErrorType.ResourcesNotFoundException);
        }
        if (pageLayout.getPageBlocks().stream().noneMatch(pageBlock -> pageBlock.getId().equals(targetBlockId))) {
            throw new CustomException("目标页面区块不存在", "TargetPageBlockNotFound", ErrorType.ResourcesNotFoundException);
        }
        pageBlockService.movePageBlock(pageLayout, blockId, targetBlockId);
    }

    @Operation(summary = "删除页面区块")
    @DeleteMapping("/{id}/blocks/{blockId}")
    public void deletePageBlock(@PathVariable Long id, @PathVariable Long blockId) {
        PageLayout pageLayout = pageLayoutService.getPageLayout(id);
        if (pageLayout.getPageBlocks().stream().noneMatch(pageBlock -> pageBlock.getId().equals(blockId))) {
            throw new CustomException("页面区块不存在", "PageBlockNotFound", ErrorType.ResourcesNotFoundException);
        }
        pageBlockService.deletePageBlock(pageLayout, blockId);
    }
}
