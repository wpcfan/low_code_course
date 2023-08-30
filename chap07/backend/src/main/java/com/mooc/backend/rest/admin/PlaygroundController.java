package com.mooc.backend.rest.admin;

import com.mooc.backend.entities.PageLayout;
import com.mooc.backend.enumerations.PageStatus;
import com.mooc.backend.enumerations.PageType;
import com.mooc.backend.enumerations.Platform;
import com.mooc.backend.repositories.PageLayoutRepository;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.stream.Stream;

@Tag(name = "JPA 查询训练场", description = "查询相关接口")
@Validated
@RestController
@RequestMapping("/api/v1/admin/playground")
@RequiredArgsConstructor
public class PlaygroundController {
    private final PageLayoutRepository pageLayoutRepository;

    @GetMapping("/top")
    public List<PageLayout> getTop2(@RequestParam Platform platform) {
        return pageLayoutRepository.findTop2ByPlatform(platform);
    }

    @GetMapping("/count")
    public long count(@RequestParam PageStatus status) {
        return pageLayoutRepository.countByStatus(status);
    }

    @GetMapping("/exists")
    public boolean exists(@RequestParam String title) {
        return pageLayoutRepository.existsByTitleContainingAllIgnoreCase(title);
    }

    @GetMapping("/first")
    public PageLayout first(@RequestParam PageStatus status) {
        return pageLayoutRepository.findFirstByStatus(status).orElseThrow();
    }

    @Transactional(readOnly = true)
    @GetMapping("/stream")
    public Stream<PageLayout> stream(@RequestParam Platform platform,
                                     @RequestParam PageType pageType) {
        var now = java.time.LocalDateTime.now();
        return pageLayoutRepository.streamByConditions(
                platform,
                pageType,
                PageStatus.PUBLISHED,
                now
        );
    }
}
