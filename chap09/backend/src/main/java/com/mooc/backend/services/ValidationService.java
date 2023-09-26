package com.mooc.backend.services;

import com.mooc.backend.entities.PageBlock;
import com.mooc.backend.entities.PageLayout;
import com.mooc.backend.errors.CustomException;
import com.mooc.backend.errors.ErrorType;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

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
}
