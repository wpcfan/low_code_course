package com.mooc.backend.services;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.mooc.backend.config.QiniuProperties;
import com.mooc.backend.errors.CustomException;
import com.mooc.backend.errors.ErrorType;
import com.qiniu.storage.BucketManager;
import com.qiniu.storage.UploadManager;
import com.qiniu.storage.model.DefaultPutRet;
import com.qiniu.util.Auth;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.io.ByteArrayInputStream;

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
            throw new CustomException("上传文件失败", e.getMessage(), ErrorType.FileUploadToQiniuException);
        }
    }
}
