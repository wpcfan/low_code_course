package com.mooc.backend.rest;

import jakarta.validation.constraints.*;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.IOException;

@Validated
@RestController
@RequestMapping("/api/v1/image")
public class ImageController {

    @GetMapping("/{width}")
    public ResponseEntity<byte[]> generateImage(
            @PathVariable @Min(12) @Max(1920) int width,
            @RequestParam(required = false, defaultValue = "Arial") @Size(min = 3, max = 20) String fontName
            ) throws IOException {
        return buildImage(width, width, width + "x" + width, Color.WHITE, Color.BLACK, fontName);
    }

    @GetMapping("/{width}/{height}")
    public ResponseEntity<byte[]> generateImage(
            @PathVariable @Min(12) @Max(1920) int width,
            @PathVariable @Min(12) @Max(1920) int height,
            @RequestParam(required = false, defaultValue = "Arial") String fontName
    ) throws IOException {
        return buildImage(width, height, width + "x" + height, Color.WHITE, Color.BLACK, fontName);
    }

    @GetMapping("/{width}/{height}/{text}")
    public ResponseEntity<byte[]> generateImage(
            @PathVariable int width,
            @PathVariable int height,
            @PathVariable @Size(min = 2, max = 10) String text,
            @RequestParam(required = false, defaultValue = "Arial") String fontName
            ) throws IOException {
        return buildImage(width, height, text, Color.WHITE, Color.BLACK, fontName);
    }

    @GetMapping("/{width}/{height}/{text}/{backgroundColor}")
    public ResponseEntity<byte[]> generateImage(
            @PathVariable int width,
            @PathVariable int height,
            @PathVariable String text,
            @PathVariable @Pattern(regexp = "^[0-9a-fA-F]{6}$") String backgroundColor,
            @RequestParam(required = false, defaultValue = "Arial") String fontName
            ) throws IOException {
        return buildImage(width, height, text, parseHexToColor(backgroundColor), Color.BLACK, fontName);
    }

    @GetMapping("/{width}/{height}/{text}/{backgroundColor}/{foregroundColor}")
    public ResponseEntity<byte[]> generateImage(
            @PathVariable int width,
            @PathVariable int height,
            @PathVariable String text,
            @PathVariable String backgroundColor,
            @PathVariable String foregroundColor,
            @RequestParam(required = false, defaultValue = "Arial") String fontName
            ) throws IOException {
        return buildImage(width, height, text, parseHexToColor(backgroundColor), parseHexToColor(foregroundColor), fontName);
    }

    private Color parseHexToColor(String hex) {
        return new Color(Integer.parseInt(hex, 16));
    }

    private ResponseEntity<byte[]> buildImage(
            int width,
            int height,
            String text,
            Color backgroundColor,
            Color foregroundColor,
            String fontName
            ) throws IOException {
        BufferedImage image = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
        Graphics2D graphics = image.createGraphics();
        graphics.setColor(backgroundColor);
        graphics.fillRect(0, 0, width, height);
        graphics.setColor(foregroundColor);
        graphics.setFont(new Font(fontName, Font.BOLD, 16));
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
