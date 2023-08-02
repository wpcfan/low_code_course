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
        return buildImage(width, width, width + "x" + width, Color.WHITE, Color.BLACK);
    }

    @GetMapping("/{width}/{height}")
    public ResponseEntity<byte[]> generateImage(@PathVariable int width, @PathVariable int height) throws IOException {
        return buildImage(width, height, width + "x" + height, Color.WHITE, Color.BLACK);
    }

    @GetMapping("/{width}/{height}/{text}")
    public ResponseEntity<byte[]> generateImage(@PathVariable int width, @PathVariable int height, @PathVariable String text) throws IOException {
        return buildImage(width, height, text, Color.WHITE, Color.BLACK);
    }

    @GetMapping("/{width}/{height}/{text}/{backgroundColor}")
    public ResponseEntity<byte[]> generateImage(@PathVariable int width, @PathVariable int height, @PathVariable String text, @PathVariable String backgroundColor) throws IOException {
        return buildImage(width, height, text, parseHexToColor(backgroundColor), Color.BLACK);
    }

    @GetMapping("/{width}/{height}/{text}/{backgroundColor}/{foregroundColor}")
    public ResponseEntity<byte[]> generateImage(@PathVariable int width, @PathVariable int height, @PathVariable String text, @PathVariable String backgroundColor, @PathVariable String foregroundColor) throws IOException {
        return buildImage(width, height, text, parseHexToColor(backgroundColor), parseHexToColor(foregroundColor));
    }

    private Color parseHexToColor(String hex) {
        return new Color(Integer.parseInt(hex, 16));
    }

    private ResponseEntity<byte[]> buildImage(int width, int height, String text, Color backgroundColor, Color foregroundColor) throws IOException {
        BufferedImage image = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
        Graphics2D graphics = image.createGraphics();
        graphics.setColor(backgroundColor);
        graphics.fillRect(0, 0, width, height);
        graphics.setColor(foregroundColor);
        graphics.setFont(new Font("Arial", Font.BOLD, 16));
        FontMetrics fontMetrics = graphics.getFontMetrics();
        int x = (width - fontMetrics.stringWidth(text)) / 2;
        int y = (height - fontMetrics.getHeight()) / 2 + fontMetrics.getAscent();
        graphics.drawString(text, x, y);
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
