package com.mooc.backend.rest.admin;

import com.mooc.backend.entities.PageBlock;
import com.mooc.backend.entities.PageLayout;
import com.mooc.backend.enumerations.BlockType;
import com.mooc.backend.errors.CustomException;
import com.mooc.backend.errors.ErrorType;
import com.mooc.backend.rest.vm.CreatePageBlockVM;
import com.mooc.backend.rest.vm.UpdatePageBlockVM;
import com.mooc.backend.services.PageBlockService;
import com.mooc.backend.services.PageLayoutService;
import com.mooc.backend.services.ValidationService;
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
    private final ValidationService validationService;

    @Operation(summary = "添加页面区块", description = """
            添加页面区块会同时添加页面区块数据
            比如添加一个图片区块，那么就会同时添加一个图片区块数据
            添加区块时，默认的排序是当前页面布局的区块数量加一。
            一个页面布局中只能有一个瀑布流区块，且瀑布流区块需要位于最后
            这意味着已有瀑布流区块的情况下，新增区块的排序会比瀑布流区块的排序小一，瀑布流还是在最后
            """)
    @PostMapping("/{id}/blocks")
    public PageBlock addPageBlock(@PathVariable Long id, @RequestBody @Valid CreatePageBlockVM pageBlockVM) {
        validationService.checkPageStatusIsDraft(id);
        boolean hasWaterfall = pageBlockService.countByTypeAndPageLayoutId(BlockType.Waterfall, id) > 0;
        // 瀑布流区块只能有一个
        if (hasWaterfall && pageBlockVM.type() == BlockType.Waterfall) {
            throw new CustomException(
                    "瀑布流区块只能有一个",
                    "WaterfallBlockExisted",
                    ErrorType.ConstraintViolationException);
        }
        PageLayout pageLayout = pageLayoutService.getPageLayout(id);
        return pageBlockService.addBlockToLayout(pageLayout, hasWaterfall, pageBlockVM);
    }

    @Operation(summary = "更新页面区块")
    @PutMapping("/{id}/blocks/{blockId}")
    public PageBlock updatePageBlock(@PathVariable Long id, @PathVariable Long blockId, @RequestBody @Valid UpdatePageBlockVM pageBlockVM) {
        validationService.checkPageStatusIsDraft(id);
        validationService.checkPageBlockNotExist(id, blockId);
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
        validationService.checkPageStatusIsDraft(id);
        PageLayout pageLayout = pageLayoutService.getPageLayout(id);
        var blocks = pageLayout.getPageBlocks();
        validationService.checkPageBlockNotExist(id, blockId);
        validationService.checkPageBlockNotExist(id, targetBlockId);
        var waterfallBlockId = blocks.stream()
                .filter(pageBlock -> pageBlock.getType() == BlockType.Waterfall)
                .findFirst()
                .map(PageBlock::getId)
                .orElseThrow();
        if (waterfallBlockId.equals(blockId) || waterfallBlockId.equals(targetBlockId)) {
            throw new CustomException("瀑布流区块不能移动", "WaterfallBlockCannotMove", ErrorType.ConstraintViolationException);
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
        validationService.checkPageStatusIsDraft(id);
        validationService.checkPageBlockNotExist(id, blockId);
        PageLayout pageLayout = pageLayoutService.getPageLayout(id);
        pageBlockService.deletePageBlock(pageLayout, blockId);
    }
}
