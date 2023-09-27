package com.mooc.backend.services;

import com.mooc.backend.entities.PageBlock;
import com.mooc.backend.entities.PageLayout;
import com.mooc.backend.enumerations.BlockType;
import com.mooc.backend.enumerations.PageStatus;
import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;
import com.mooc.backend.errors.CustomException;
import com.mooc.backend.errors.ErrorType;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@RequiredArgsConstructor
@Service
public class ValidationService {
    private final PageLayoutService pageLayoutService;
    private final PageBlockService pageBlockService;
    private final PageBlockDataService pageBlockDataService;

    public void checkPageBlockNotExist(Long id, Long blockId) {
        PageLayout pageLayout = pageLayoutService.getPageLayout(id);
        if (pageLayout.getPageBlocks().stream().noneMatch(pageBlock -> pageBlock.getId().equals(blockId))) {
            throw new CustomException("页面区块不存在", "PageBlockNotFound", ErrorType.ResourcesNotFoundException);
        }
    }

    public void checkPageBlockDataNotExist(Long blockId, Long dataId) {
        PageBlock pageBlock = pageBlockService.getPageBlock(blockId);
        if (pageBlock.getData().stream().noneMatch(pageBlockData -> pageBlockData.getId().equals(dataId))) {
            throw new CustomException("页面区块数据不存在", "PageBlockDataNotFound", ErrorType.ResourcesNotFoundException);
        }
    }

    public void checkPageStatusIsDraft(Long id) {
        PageLayout pageLayout = pageLayoutService.getPageLayout(id);
        if (pageLayout.getStatus() != PageStatus.DRAFT) {
            throw new CustomException("页面不是草稿状态", "PageNotDraft", ErrorType.ConstraintViolationException);
        }
    }

    public void checkPublishTimeConflict(LocalDateTime time, Platform platform, PageType pageType) {
        if (pageLayoutService.checkPublishTimeConflict(time, platform, pageType)) {
            throw new CustomException("发布时间冲突", "PublishTimeConflict", ErrorType.ConstraintViolationException);
        }
    }

    public void checkWaterfallBlockCannotMove(Long id, Long blockId) {
        PageLayout pageLayout = pageLayoutService.getPageLayout(id);
        var blocks = pageLayout.getPageBlocks();
        var waterfallBlockId = blocks.stream()
                .filter(pageBlock -> pageBlock.getType() == BlockType.Waterfall)
                .findFirst()
                .map(PageBlock::getId);
        if (waterfallBlockId.isPresent() && waterfallBlockId.get().equals(blockId) ) {
            throw new CustomException("瀑布流区块不能移动", "WaterfallBlockCannotMove", ErrorType.ConstraintViolationException);
        }
    }
}
