package com.mooc.backend.rest.admin;

import com.mooc.backend.entities.PageBlock;
import com.mooc.backend.entities.PageBlockData;
import com.mooc.backend.rest.vm.CreateOrUpdatePageBlockDataVM;
import com.mooc.backend.services.PageBlockDataService;
import com.mooc.backend.services.PageBlockService;
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
        @Tag(name = "页面区块数据管理", description = "页面区块数据管理相关接口"),
})
@Validated
@RestController
@RequestMapping("/api/v1/admin/layouts")
@RequiredArgsConstructor
public class PageBlockDataAdminController {
    private final PageBlockService pageBlockService;
    private final PageBlockDataService pageBlockDataService;
    private final ValidationService validationService;
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
    @Operation(summary = "添加页面区块数据", description = """
            注意，我们将忽略客户端传入的区块的顺序
            所有新增的区块数据的排序都位于已有区块数据的后面
            比如排序为 1, 2, 3, 4, 5 的区块数据，如果添加一个新的区块数据，
            那么新的区块数据的排序会变成 6.
            """)
    @PostMapping("/{id}/blocks/{blockId}/data")
    public PageBlockData addPageBlockData(
            @PathVariable Long id,
            @PathVariable Long blockId,
            @RequestBody @Valid CreateOrUpdatePageBlockDataVM pageBlockDataVM) {
        validationService.checkPageBlockNotExist(id, blockId);
        PageBlock pageBlock = pageBlockService.getPageBlock(blockId);
        PageBlockData pageBlockData = new PageBlockData();
        pageBlockData.setPageBlock(pageBlock);
        pageBlockData.setContent(pageBlockDataVM.content());
        pageBlockData.setSort(pageBlock.getData().size() + 1);
        return pageBlockDataService.savePageBlockData(pageBlockData);
    }


    @Operation(summary = "更新页面区块数据")
    @PutMapping("/{id}/blocks/{blockId}/data/{dataId}")
    public PageBlockData updatePageBlockData(@PathVariable Long id, @PathVariable Long blockId, @PathVariable Long dataId, @RequestBody @Valid CreateOrUpdatePageBlockDataVM pageBlockDataVM) {
        validationService.checkPageBlockNotExist(id, blockId);
        validationService.checkPageBlockDataNotExist(blockId, dataId);
        PageBlockData pageBlockData = pageBlockDataService.getPageBlockData(dataId);
        pageBlockData.setContent(pageBlockDataVM.content());
        return pageBlockDataService.savePageBlockData(pageBlockData);
    }



    @Operation(summary = "移动页面区块数据", description = """
            此 API 的目的是为了改变页面区块数据的排序
            比如排序为 1, 2, 3, 4, 5 的区块数据，如果移动 3 号区块数据到 5 号区块数据之后，
            那么 3 号区块数据的排序会变成 5，4 号区块数据的排序会变成 3，5 号区块数据的排序会变成 4.
            注意需要区分两种方向的移动，还是上面的例子，如果我们移动 3 号区块数据到 1 号区块数据之前
            那么 3 号区块数据的排序会变成 1，1 号区块数据的排序会变成 2，2 号区块数据的排序会变成 3.
            建议客户端在执行移动区块数据之后，自行更新区块数据排序，或者重新获取区块
            """)
    @PutMapping("/{id}/blocks/{blockId}/data/{dataId}/sort/{targetDataId}")
    public void movePageBlockData(@PathVariable Long id, @PathVariable Long blockId, @PathVariable Long dataId, @PathVariable Long targetDataId) {
        validationService.checkPageBlockNotExist(id, blockId);
        validationService.checkPageBlockDataNotExist(blockId, dataId);
        validationService.checkPageBlockDataNotExist(blockId, targetDataId);
        PageBlock pageBlock = pageBlockService.getPageBlock(blockId);
        pageBlockDataService.movePageBlockData(pageBlock, dataId, targetDataId);
    }

    @Operation(summary = "删除页面区块数据", description = """
            删除页面区块数据会同时更新所有排序在此区块数据之后的区块数据的排序
            比如排序为 1, 2, 3, 4, 5 的区块数据，如果删除 3 号区块数据，
            那么 4 号区块数据的排序会变成 3，5 号区块数据的排序会变成 4.
            建议客户端在执行删除区块数据之后，自行更新区块数据排序，或者重新获取区块
            """)
    @DeleteMapping("/{id}/blocks/{blockId}/data/{dataId}")
    public void deletePageBlockData(@PathVariable Long id, @PathVariable Long blockId, @PathVariable Long dataId) {
        validationService.checkPageBlockNotExist(id, blockId);
        validationService.checkPageBlockDataNotExist(blockId, dataId);
        PageBlock pageBlock = pageBlockService.getPageBlock(blockId);
        pageBlockDataService.deletePageBlockData(pageBlock, dataId);
    }

}
