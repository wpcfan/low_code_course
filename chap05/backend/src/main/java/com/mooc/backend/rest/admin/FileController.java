package com.mooc.backend.rest.admin;

import com.mooc.backend.config.QiniuProperties;
import com.mooc.backend.services.QiniuService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

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
        // 1. 怎么处理 file，也就是说是保存到哪里？本地？还是云端？ - OSS
        // 2. 如何返回文件的 URL？ - 本地：http://localhost:8080/xxx.jpg；云端：https://xxx.oss-cn-beijing.aliyuncs.com/xxx.jpg
        // 3. 是否只需返回 URL？也就是说文件的信息结构是什么？ 文件结构至少包含 key 和 url
        var json = qiniuService.upload(file.getBytes(), "123");
        return new FileVM(json.key, properties.getDomain() + "/" + json.key);
    }

    @GetMapping("/files")
    public List<FileVM> list() {
        // 1. 怎么获取文件列表？本地？还是云端？ - OSS
        // 2. 文件列表的信息结构是什么？ 未定
        return List.of(new FileVM("123", "http://localhost:8080/xxx.jpg"));
    }

    @DeleteMapping("/files/{key}")
    public void delete(@PathVariable String key) {
        // 1. 怎么删除文件？本地？还是云端？ - OSS
        // 2. 文件的信息结构是什么？ 文件结构至少包含 key 和 url
    }

}
