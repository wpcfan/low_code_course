package com.mooc.backend.utils;

import org.springframework.util.StringUtils;

import java.util.UUID;

public class FileUtils {
    public static String buildFileKey(String fileName) {
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
