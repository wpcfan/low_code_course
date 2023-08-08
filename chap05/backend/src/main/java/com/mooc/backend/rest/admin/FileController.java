package com.mooc.backend.rest.admin;

import com.mooc.backend.config.QiniuProperties;
import com.mooc.backend.services.QiniuService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
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
@Tag(name = "文件管理", description = "文件管理相关接口，包括上传、列表和删除")
@RestController
@RequestMapping("/api/v1/admin")
@RequiredArgsConstructor
public class FileController {
    private final QiniuService qiniuService;
    private final QiniuProperties properties;
    public record FileVM(String key, String url) {}

    @Operation(summary = "上传一个文件")
    @ApiResponses({
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "200",
                    description = "上传成功",
                    content = @io.swagger.v3.oas.annotations.media.Content(
                            mediaType = "application/json",
                            schema = @io.swagger.v3.oas.annotations.media.Schema(implementation = FileVM.class),
                            examples = {
                                    @io.swagger.v3.oas.annotations.media.ExampleObject(
                                            name = "上传成功示例",
                                            value = """
                                            {
                                                "key": "123.png",
                                                "url": "https://mooc.com/123.png"
                                            }
                                            """
                                    )
                            }
                    )
            ),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "400", description = "上传失败")
    })
    @PostMapping(value = "/file", consumes = "multipart/form-data")
    public FileVM upload(
            @Parameter(description = "文件", required = true)
            @RequestParam
            MultipartFile file) throws IOException {
        var key = buildFileKey(file.getOriginalFilename());
        var json = qiniuService.upload(file.getBytes(), key);
        return new FileVM(json.key, properties.getDomain() + "/" + json.key);
    }

    @Operation(summary = "文件列表")
    @GetMapping("/files")
    public List<FileVM> list(
            @Parameter(description = "文件名前缀")
            @RequestParam(required = false, defaultValue = "") String prefix,
            @Parameter(description = "上一次获取文件列表时返回的 marker")
            @RequestParam(required = false, defaultValue = "") String marker,
            @Parameter(description = "每次获取文件的数量")
            @RequestParam(required = false, defaultValue = "1000") int limit
    ) {

        return qiniuService.list(prefix, marker, limit).stream()
                .map(fileInfo -> new FileVM(fileInfo.key, properties.getDomain() + "/" + fileInfo.key))
                .toList();
    }

    @Operation(summary = "删除文件")
    @DeleteMapping("/files/{key}")
    public void delete(
            @Parameter(description = "文件的唯一标识")
            @PathVariable
            String key) {
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
