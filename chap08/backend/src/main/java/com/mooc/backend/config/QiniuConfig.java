package com.mooc.backend.config;

import com.qiniu.storage.BucketManager;
import com.qiniu.storage.UploadManager;
import com.qiniu.util.Auth;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class QiniuConfig {
    @Bean
    public Auth auth(QiniuProperties properties) {
        return Auth.create(properties.getAccessKey(), properties.getSecretKey());
    }

    @Bean
    public com.qiniu.storage.Configuration configuration() {
        var cfg = new com.qiniu.storage.Configuration(com.qiniu.storage.Region.autoRegion());
        cfg.useHttpsDomains = false;
        cfg.resumableUploadAPIVersion = com.qiniu.storage.Configuration.ResumableUploadAPIVersion.V2;
        return cfg;
    }

    @Bean
    public BucketManager bucketManager(Auth auth, com.qiniu.storage.Configuration configuration) {
        return new BucketManager(auth, configuration);
    }

    @Bean
    public UploadManager uploadManager(com.qiniu.storage.Configuration configuration) {
        return new UploadManager(configuration);
    }
}
