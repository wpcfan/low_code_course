package com.mooc.backend.rest.admin;

import com.mooc.backend.config.QiniuProperties;
import com.mooc.backend.services.QiniuService;
import lombok.RequiredArgsConstructor;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.UUID;

/**
 * 文件管理
 * 1. 上传文件
 * 2. 文件列表
 * 3. 删除文件
 */
@RestController
@RequestMapping("/api/v1/admin")
@RequiredArgsConstructor
public class FileController {
    private final QiniuService qiniuService;
    private final QiniuProperties properties;
    public record FileVM(String key, String url) {}
    @PostMapping(value = "/file", consumes = "multipart/form-data")
    public FileVM upload(@RequestParam MultipartFile file) throws IOException {
        var key = buildFileKey(file.getOriginalFilename());
        var json = qiniuService.upload(file.getBytes(), key);
        return new FileVM(json.key, properties.getDomain() + "/" + json.key);
    }

    @GetMapping("/files")
    public List<FileVM> list(
            @RequestParam(required = false, defaultValue = "") String prefix,
            @RequestParam(required = false, defaultValue = "") String marker,
            @RequestParam(required = false, defaultValue = "1000") int limit
    ) {

        return qiniuService.list(prefix, marker, limit).stream()
                .map(fileInfo -> new FileVM(fileInfo.key, properties.getDomain() + "/" + fileInfo.key))
                .toList();
    }

    @DeleteMapping("/files/{key}")
    public void delete(@PathVariable String key) {
        qiniuService.delete(key);
    }

    private static String buildFileKey(String fileName) {
        var uuid = UUID.randomUUID().toString();
        if (!StringUtils.hasText(fileName)) {
            return uuid;
        }
        var splits = fileName.split("\\.");
        if (splits.length == 1) {
            return fileName + "_" + uuid;
        }
        var suffix = splits[splits.length - 1];
        return splits[0] + "_" + uuid + "." + suffix;
    }

}
