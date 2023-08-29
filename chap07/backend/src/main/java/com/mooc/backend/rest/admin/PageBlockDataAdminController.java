package com.mooc.backend.rest.admin;

import com.mooc.backend.entities.PageBlock;
import com.mooc.backend.entities.PageBlockData;
import com.mooc.backend.entities.PageLayout;
import com.mooc.backend.errors.CustomException;
import com.mooc.backend.errors.ErrorType;
import com.mooc.backend.rest.vm.CreateOrUpdatePageBlockDataVM;
import com.mooc.backend.services.PageBlockDataService;
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
        @Tag(name = "页面区块数据管理", description = "页面区块数据管理相关接口"),
})
@Validated
@RestController
@RequestMapping("/api/v1/admin/layouts")
@RequiredArgsConstructor
public class PageBlockDataAdminController {
    private final PageLayoutService pageLayoutService;
    private final PageBlockService pageBlockService;
    private final PageBlockDataService pageBlockDataService;

    @io.swagger.v3.oas.annotations.parameters.RequestBody(
            description = "页面区块数据",
            required = true,
            content = @io.swagger.v3.oas.annotations.media.Content(
                    mediaType = "application/json",
                    schema = @io.swagger.v3.oas.annotations.media.Schema(
                            implementation = CreateOrUpdatePageBlockDataVM.class
                    ),
                    examples = {
                            @io.swagger.v3.oas.annotations.media.ExampleObject(
                                    name = "图片区块数据示例",
                                    value = """
                                    {
                                        "content": {
                                            "image": "https://picsum.photos/200/300",
                                            "link": {
                                                "type": "url",
                                                "value": "https://www.baidu.com"
                                            },
                                            "title": "图片标题"
                                        },
                                        "sort": 1
                                    }
                                    """
                            ),
                            @io.swagger.v3.oas.annotations.media.ExampleObject(
                                    name = "商品区块数据示例",
                                    value = """
                                    {
                                        "content": {
                                            "id": 1,
                                            "sku": "sku_001",
                                            "name": "xPhone手机",
                                            "description": "这是一段商品描述",
                                            "images": [
                                                "https://picsum.photos/200/300"
                                            ],
                                            "price": "¥1234.00",
                                            "originalPrice": "¥1300.00"
                                        },
                                        "sort": 1
                                    }
                                    """
                            ),
                            @io.swagger.v3.oas.annotations.media.ExampleObject(
                                    name = "分类区块数据示例",
                                    value = """
                                    {
                                        "content": {
                                            "id": 1,
                                            "name": "分类名称",
                                            "code": "cat_001"
                                        },
                                        "sort": 1
                                    }
                                    """
                            ),
                    }
            )
    )
    @Operation(summary = "添加页面区块数据")
    @PostMapping("/{id}/blocks/{blockId}/data")
    public PageBlockData addPageBlockData(
            @PathVariable Long id,
            @PathVariable Long blockId,
            @RequestBody @Valid CreateOrUpdatePageBlockDataVM pageBlockDataVM) {
        PageLayout pageLayout = pageLayoutService.getPageLayout(id);
        if (pageLayout.getPageBlocks().stream().noneMatch(pageBlock -> pageBlock.getId().equals(blockId))) {
            throw new CustomException("页面区块不存在", "PageBlockNotFound", ErrorType.ResourcesNotFoundException);
        }
        PageBlock pageBlock = pageBlockService.getPageBlock(blockId);
        PageBlockData pageBlockData = new PageBlockData();
        pageBlockData.setPageBlock(pageBlock);
        pageBlockData.setContent(pageBlockDataVM.content());
        pageBlockData.setSort(pageBlockDataVM.sort());
        return pageBlockDataService.savePageBlockData(pageBlockData);
    }

    @Operation(summary = "更新页面区块数据")
    @PutMapping("/{id}/blocks/{blockId}/data/{dataId}")
    public PageBlockData updatePageBlockData(@PathVariable Long id, @PathVariable Long blockId, @PathVariable Long dataId, @RequestBody @Valid CreateOrUpdatePageBlockDataVM pageBlockDataVM) {
        PageLayout pageLayout = pageLayoutService.getPageLayout(id);
        if (pageLayout.getPageBlocks().stream().noneMatch(pageBlock -> pageBlock.getId().equals(blockId))) {
            throw new CustomException("页面区块不存在", "PageBlockNotFound", ErrorType.ResourcesNotFoundException);
        }
        PageBlock pageBlock = pageBlockService.getPageBlock(blockId);
        if (pageBlock.getData().stream().anyMatch(pageBlockData -> pageBlockData.getId().equals(dataId))) {
            throw new CustomException("页面区块数据不存在", "PageBlockDataNotFound", ErrorType.ResourcesNotFoundException);
        }
        PageBlockData pageBlockData = pageBlockDataService.getPageBlockData(dataId);
        pageBlockData.setContent(pageBlockDataVM.content());
        return pageBlockDataService.savePageBlockData(pageBlockData);
    }

    @Operation(summary = "删除页面区块数据")
    @DeleteMapping("/{id}/blocks/{blockId}/data/{dataId}")
    public void deletePageBlockData(@PathVariable Long id, @PathVariable Long blockId, @PathVariable Long dataId) {
        PageLayout pageLayout = pageLayoutService.getPageLayout(id);
        if (pageLayout.getPageBlocks().stream().noneMatch(pageBlock -> pageBlock.getId().equals(blockId))) {
            throw new CustomException("页面区块不存在", "PageBlockNotFound", ErrorType.ResourcesNotFoundException);
        }
        PageBlock pageBlock = pageBlockService.getPageBlock(blockId);
        if (pageBlock.getData().stream().anyMatch(pageBlockData -> pageBlockData.getId().equals(dataId))) {
            throw new CustomException("页面区块数据不存在", "PageBlockDataNotFound", ErrorType.ResourcesNotFoundException);
        }
        pageBlockDataService.deletePageBlockData(dataId);
    }
}
