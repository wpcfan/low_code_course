package com.mooc.backend.services;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.mooc.backend.config.QiniuProperties;
import com.mooc.backend.errors.CustomException;
import com.mooc.backend.errors.ErrorType;
import com.qiniu.storage.BucketManager;
import com.qiniu.storage.UploadManager;
import com.qiniu.storage.model.DefaultPutRet;
import com.qiniu.storage.model.FileInfo;
import com.qiniu.util.Auth;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.io.ByteArrayInputStream;
import java.util.Arrays;
import java.util.List;

@RequiredArgsConstructor
@Service
public class QiniuService {

    private final UploadManager uploadManager;
    private final BucketManager bucketManager;
    private final Auth auth;
    private final QiniuProperties properties;

    public DefaultPutRet upload(byte[] bytes, String key) {
        try {
            ByteArrayInputStream inputStream = new ByteArrayInputStream(bytes);
            ObjectMapper objectMapper = new ObjectMapper();
            var response = uploadManager.put(
                    inputStream,
                    key,
                    auth.uploadToken(properties.getBucket()),
                    null,
                    null);
            var json = objectMapper.readValue(response.bodyString(), DefaultPutRet.class);
            return json;
        } catch (Exception e) {
            throw new CustomException("上传文件失败", e.getMessage(), ErrorType.QiniuFileUploadException);
        }
    }

    public List<FileInfo> list(String prefix, String marker, int limit) {
        try {
            var files = bucketManager.listFiles(
                    properties.getBucket(),
                    prefix,
                    marker,
                    limit,
                    "");
            return Arrays.stream(files.items).toList();
        } catch (Exception e) {
            throw new CustomException("获取文件列表失败", e.getMessage(), ErrorType.QiniuFileListException);
        }
    }

    public void delete(String key) {
        try {
            bucketManager.delete(properties.getBucket(), key);
        } catch (Exception e) {
            throw new CustomException("删除文件失败", e.getMessage(), ErrorType.QiniuFileDeleteException);
        }
    }
}
