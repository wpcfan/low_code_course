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

    @Operation(summary = "添加页面区块", description = """
            添加页面区块会同时添加页面区块数据
            比如添加一个图片区块，那么就会同时添加一个图片区块数据
            添加区块时，默认的排序是当前页面布局的区块数量加一
            """)
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

    @Operation(summary = "移动页面区块", description = """
            移动页面区块会同时更新所有排序在此区块之后的区块的排序
            比如排序为 1, 2, 3, 4, 5 的区块，如果移动 3 号区块到 5 号区块之后，
            那么 4 号区块的排序会变成 3，5 号区块的排序会变成 4.
            也就是 3 号区块后面的区块排序都会减一。
            反方向的移动也是一样的，还是以 1, 2, 3, 4, 5 的区块为例，
            如果移动 5 号区块到 3 号区块之前，那么 3 号区块的排序会变成 4，4 号区块的排序会变成 5.
            也就是 3 号区块前面的区块排序都会加一。
            建议客户端在执行移动区块之后，自行更新区块排序，或者重新获取页面布局
            """)
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

    @Operation(summary = "删除页面区块", description = """
            删除页面区块会同时删除页面区块数据
            而且会同时更新所有排序在此区块之后的区块的排序
            比如排序为 1, 2, 3, 4, 5 的区块，如果删除 3 号区块，
            那么 4 号区块的排序会变成 3，5 号区块的排序会变成 4.
            建议客户端在执行删除区块之后，自行更新区块排序，或者重新获取页面布局
            """)
    @DeleteMapping("/{id}/blocks/{blockId}")
    public void deletePageBlock(@PathVariable Long id, @PathVariable Long blockId) {
        PageLayout pageLayout = pageLayoutService.getPageLayout(id);
        if (pageLayout.getPageBlocks().stream().noneMatch(pageBlock -> pageBlock.getId().equals(blockId))) {
            throw new CustomException("页面区块不存在", "PageBlockNotFound", ErrorType.ResourcesNotFoundException);
        }
        pageBlockService.deletePageBlock(pageLayout, blockId);
    }
}
