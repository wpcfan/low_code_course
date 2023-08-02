package com.mooc.backend.rest;

import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.IOException;

@RestController
@RequestMapping("/api/v1/image")
public class ImageController {

    @GetMapping("/{width}")
    public ResponseEntity<byte[]> generateImage(@PathVariable int width) throws IOException {
        return buildImage(width);
    }

    private ResponseEntity<byte[]> buildImage(int width) throws IOException {
        BufferedImage image = new BufferedImage(width, width, BufferedImage.TYPE_INT_RGB);
        Graphics2D graphics = image.createGraphics();
        graphics.setColor(Color.WHITE);
        graphics.fillRect(0, 0, width, width);
        graphics.setColor(Color.BLACK);
        graphics.drawString("Hello World!", 10, 10);
        graphics.dispose();
        // 创建一个字节数组输出流
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        // 将图片写入到字节数组输出流中
        ImageIO.write(image, "png", baos);
        return ResponseEntity.ok()
                .contentType(MediaType.IMAGE_PNG)
                .body(baos.toByteArray());
    }
}
