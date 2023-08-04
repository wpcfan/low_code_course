package com.mooc.backend.rest;

import java.awt.Color;
import java.awt.Font;
import java.awt.FontMetrics;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.IOException;

import javax.imageio.ImageIO;

import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

@Validated
@RestController
@RequestMapping("/api/v1/image")
public class ImageController {

    private final static String FONT_NAME_REGEX = "(?i)^(Arial|Hei|Courier New)$";
    private final static String DEFAULT_FONT_NAME = "Arial";
    private final static String HEX_COLOR_REGEX = "^[0-9a-fA-F]{6}$";
    private final static int MAX_WIDTH = 1920;
    private final static int MAX_HEIGHT = 1920;
    private final static int MIN_WIDTH = 12;
    private final static int MIN_HEIGHT = 12;
    private final static int MAX_TEXT_LENGTH = 10;
    private final static int MIN_TEXT_LENGTH = 2;
    private final static int MAX_FONT_SIZE = 72;
    private final static int MIN_FONT_SIZE = 12;
    private final static String DEFAULT_BACKGROUND_COLOR = "FFFFFF";
    private final static String DEFAULT_TEXT_COLOR = "000000";
    private final static String DEFAULT_FONT_STYLE = "PLAIN";

    enum FontStyle {
        PLAIN(Font.PLAIN), BOLD(Font.BOLD), ITALIC(Font.ITALIC);

        private int value;

        FontStyle(int value) {
            this.value = value;
        }

        public int getValue() {
            return value;
        }
    }

    /**
     * 除了使用正则表达式来约束参数，还可以使用枚举类来约束参数
     */
    enum FontName {
        ARIAL("Arial"), HEI("Hei"), COURIER_NEW("Courier New");

        private String value;

        FontName(String value) {
            this.value = value;
        }

        public String getValue() {
            return value;
        }
    }

    @GetMapping("/{width}")
    public ResponseEntity<byte[]> generateImage(
            @PathVariable @Min(MIN_WIDTH) @Max(MAX_WIDTH) int width,
            @RequestParam(required = false, defaultValue = DEFAULT_FONT_NAME) @Pattern(regexp = FONT_NAME_REGEX) String fontName,
            @RequestParam(required = false, defaultValue = DEFAULT_FONT_STYLE) FontStyle fontStyle,
            @RequestParam(required = false, defaultValue = MIN_FONT_SIZE
                    + "") @Min(MIN_FONT_SIZE) @Max(MAX_FONT_SIZE) int fontSize)
            throws IOException {
        return buildImage(width, width, width + "x" + width, parseHexToColor(DEFAULT_BACKGROUND_COLOR), parseHexToColor(DEFAULT_TEXT_COLOR), fontName, fontStyle.getValue(),
                fontSize);
    }

    @GetMapping("/{width}/{height}")
    public ResponseEntity<byte[]> generateImage(
            @PathVariable @Min(MIN_WIDTH) @Max(MAX_WIDTH) int width,
            @PathVariable @Min(MIN_HEIGHT) @Max(MAX_HEIGHT) int height,
            @RequestParam(required = false, defaultValue = DEFAULT_FONT_NAME) @Pattern(regexp = FONT_NAME_REGEX) String fontName,
            @RequestParam(required = false, defaultValue = DEFAULT_FONT_STYLE) FontStyle fontStyle,
            @RequestParam(required = false, defaultValue = MIN_FONT_SIZE
                    + "") @Min(MIN_FONT_SIZE) @Max(MAX_FONT_SIZE) int fontSize)
            throws IOException {
        return buildImage(width, height, width + "x" + height, parseHexToColor(DEFAULT_BACKGROUND_COLOR), parseHexToColor(DEFAULT_TEXT_COLOR), fontName, fontStyle.getValue(),
                fontSize);
    }

    @GetMapping("/{width}/{height}/{text}")
    public ResponseEntity<byte[]> generateImage(
            @PathVariable @Min(MIN_WIDTH) @Max(MAX_WIDTH) int width,
            @PathVariable @Min(MIN_HEIGHT) @Max(MAX_HEIGHT) int height,
            @PathVariable @Size(min = MIN_TEXT_LENGTH, max = MAX_TEXT_LENGTH) String text,
            @RequestParam(required = false, defaultValue = DEFAULT_FONT_NAME) @Pattern(regexp = FONT_NAME_REGEX) String fontName,
            @RequestParam(required = false, defaultValue = DEFAULT_FONT_STYLE) FontStyle fontStyle,
            @RequestParam(required = false, defaultValue = MIN_FONT_SIZE
                    + "") @Min(MIN_FONT_SIZE) @Max(MAX_FONT_SIZE) int fontSize)
            throws IOException {
        return buildImage(width, height, text, parseHexToColor(DEFAULT_BACKGROUND_COLOR), parseHexToColor(DEFAULT_TEXT_COLOR), fontName, fontStyle.getValue(), fontSize);
    }

    @GetMapping("/{width}/{height}/{text}/{backgroundColor}")
    public ResponseEntity<byte[]> generateImage(
            @PathVariable @Min(MIN_WIDTH) @Max(MAX_WIDTH) int width,
            @PathVariable @Min(MIN_HEIGHT) @Max(MAX_HEIGHT) int height,
            @PathVariable @Size(min = MIN_TEXT_LENGTH, max = MAX_TEXT_LENGTH) String text,
            @PathVariable @Pattern(regexp = HEX_COLOR_REGEX) String backgroundColor,
            @RequestParam(required = false, defaultValue = DEFAULT_FONT_NAME) @Pattern(regexp = FONT_NAME_REGEX) String fontName,
            @RequestParam(required = false, defaultValue = DEFAULT_FONT_STYLE) FontStyle fontStyle,
            @RequestParam(required = false, defaultValue = MIN_FONT_SIZE
                    + "") @Min(MIN_FONT_SIZE) @Max(MAX_FONT_SIZE) int fontSize)
            throws IOException {
        return buildImage(width, height, text, parseHexToColor(backgroundColor), parseHexToColor(DEFAULT_TEXT_COLOR), fontName,
                fontStyle.getValue(), fontSize);
    }

    @GetMapping("/{width}/{height}/{text}/{backgroundColor}/{textColor}")
    public ResponseEntity<byte[]> generateImage(
            @PathVariable @Min(MIN_WIDTH) @Max(MAX_WIDTH) int width,
            @PathVariable @Min(MIN_HEIGHT) @Max(MAX_HEIGHT) int height,
            @PathVariable @Size(min = MIN_TEXT_LENGTH, max = MAX_TEXT_LENGTH) String text,
            @PathVariable @Pattern(regexp = HEX_COLOR_REGEX) String backgroundColor,
            @PathVariable @Pattern(regexp = HEX_COLOR_REGEX) String textColor,
            @RequestParam(required = false, defaultValue = DEFAULT_FONT_NAME) @Pattern(regexp = FONT_NAME_REGEX) String fontName,
            @RequestParam(required = false, defaultValue = DEFAULT_FONT_STYLE) FontStyle fontStyle,
            @RequestParam(required = false, defaultValue = MIN_FONT_SIZE
                    + "") @Min(MIN_FONT_SIZE) @Max(MAX_FONT_SIZE) int fontSize)
            throws IOException {
        return buildImage(width, height, text, parseHexToColor(backgroundColor), parseHexToColor(textColor),
                fontName, fontStyle.getValue(), fontSize);
    }

    private Color parseHexToColor(String hex) {
        return new Color(Integer.parseInt(hex, 16));
    }

    private ResponseEntity<byte[]> buildImage(
            int width,
            int height,
            String text,
            Color backgroundColor,
            Color textColor,
            String fontName,
            int fontStyle,
            int fontSize) throws IOException {
        BufferedImage image = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
        Graphics2D graphics = image.createGraphics();
        graphics.setColor(backgroundColor);
        graphics.fillRect(0, 0, width, height);
        graphics.setColor(textColor);
        graphics.setFont(new Font(fontName, fontStyle, fontSize));
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
