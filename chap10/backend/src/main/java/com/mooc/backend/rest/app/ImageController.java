package com.mooc.backend.rest.app;

import com.mooc.backend.constants.Constants;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.ErrorResponse;
import org.springframework.web.bind.annotation.*;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.IOException;

@Slf4j
@Tag(name = "占位图片", description = "占位图片生成接口")
@Validated
@RestController
@RequestMapping("/api/v1/app/image")
public class ImageController {

    @Getter
    enum FontStyle {
        PLAIN(Font.PLAIN), BOLD(Font.BOLD), ITALIC(Font.ITALIC);

        private final int value;

        FontStyle(int value) {
            this.value = value;
        }
    }

    /**
     * 除了使用正则表达式来约束参数，还可以使用枚举类来约束参数
     */
    @Getter
    enum FontName {
        ARIAL("Arial"), HEI("Hei"), COURIER_NEW("Courier New");

        private final String value;

        FontName(String value) {
            this.value = value;
        }
    }

    @Operation(
            summary = "根据指定的宽度生成图片",
            description = "根据指定的宽度生成图片，默认是正方形",
            responses = {
                @io.swagger.v3.oas.annotations.responses.ApiResponse(
                        responseCode = "200",
                        description = "图片生成成功",
                        content = @io.swagger.v3.oas.annotations.media.Content(
                                mediaType = MediaType.IMAGE_PNG_VALUE)),
                @io.swagger.v3.oas.annotations.responses.ApiResponse(
                        responseCode = "400",
                        description = "请求参数错误",
                        content = @io.swagger.v3.oas.annotations.media.Content(
                                mediaType = MediaType.APPLICATION_JSON_VALUE,
                                schema = @io.swagger.v3.oas.annotations.media.Schema(
                                        implementation = ErrorResponse.class))
                ),
                @io.swagger.v3.oas.annotations.responses.ApiResponse(responseCode = "500", description = "服务器内部错误")
            },
            servers = {
                @io.swagger.v3.oas.annotations.servers.Server(url = "http://localhost:8080", description = "本地服务器"),
                @io.swagger.v3.oas.annotations.servers.Server(url = "https://mooc.com", description = "线上服务器")
            })
    @GetMapping("/{width}")
    public ResponseEntity<byte[]> generateImage(
            @Parameter(description = "图片宽度，最小值为 12，最大值为 1920", example = "200")
            @PathVariable
            @Min(Constants.MIN_WIDTH)
            @Max(Constants.MAX_WIDTH)
            int width,
            @Parameter(description = "字体名称，可选值为 Arial、Hei、Courier New", example = "Arial")
            @RequestParam(required = false, defaultValue = Constants.DEFAULT_FONT_NAME)
            @Pattern(regexp = Constants.FONT_NAME_REGEX)
            String fontName,
            @Parameter(description = "字体样式，可选值为 PLAIN、BOLD、ITALIC", example = "PLAIN")
            @RequestParam(required = false, defaultValue = Constants.DEFAULT_FONT_STYLE)
            FontStyle fontStyle,
            @Parameter(description = "字体大小，最小值为 12，最大值为 72", example = "12")
            @RequestParam(required = false, defaultValue = Constants.MIN_FONT_SIZE + "")
            @Min(Constants.MIN_FONT_SIZE)
            @Max(Constants.MAX_FONT_SIZE)
            int fontSize)
            throws IOException {
        log.debug("ImageController: width: {}", width);
        return buildImage(width, width, width + "x" + width, parseHexToColor(Constants.DEFAULT_BACKGROUND_COLOR), parseHexToColor(Constants.DEFAULT_TEXT_COLOR), fontName, fontStyle.getValue(),
                fontSize);
    }

    @Operation(summary = "根据指定的宽度和高度生成图片", description = "根据指定的宽度和高度生成图片")
    @GetMapping("/{width}/{height}")
    public ResponseEntity<byte[]> generateImage(
            @Parameter(description = "图片宽度，最小值为 12，最大值为 1920", example = "200")
            @PathVariable
            @Min(Constants.MIN_WIDTH)
            @Max(Constants.MAX_WIDTH)
            int width,
            @Parameter(description = "图片高度，最小值为 12，最大值为 1920", example = "200")
            @PathVariable
            @Min(Constants.MIN_HEIGHT)
            @Max(Constants.MAX_HEIGHT)
            int height,
            @Parameter(description = "字体名称，可选值为 Arial、Hei、Courier New", example = "Arial")
            @RequestParam(required = false, defaultValue = Constants.DEFAULT_FONT_NAME)
            @Pattern(regexp = Constants.FONT_NAME_REGEX)
            String fontName,
            @Parameter(description = "字体样式，可选值为 PLAIN、BOLD、ITALIC", example = "PLAIN")
            @RequestParam(required = false, defaultValue = Constants.DEFAULT_FONT_STYLE)
            FontStyle fontStyle,
            @Parameter(description = "字体大小，最小值为 12，最大值为 72", example = "12")
            @RequestParam(required = false, defaultValue = Constants.MIN_FONT_SIZE + "")
            @Min(Constants.MIN_FONT_SIZE)
            @Max(Constants.MAX_FONT_SIZE)
            int fontSize)
            throws IOException {
        return buildImage(width, height, width + "x" + height, parseHexToColor(Constants.DEFAULT_BACKGROUND_COLOR), parseHexToColor(Constants.DEFAULT_TEXT_COLOR), fontName, fontStyle.getValue(),
                fontSize);
    }

    @Operation(summary = "根据指定的宽度、高度和文字生成图片", description = "根据指定的宽度、高度和文字生成图片")
    @GetMapping("/{width}/{height}/{text}")
    public ResponseEntity<byte[]> generateImage(
            @Parameter(description = "图片宽度，最小值为 12，最大值为 1920", example = "200")
            @PathVariable
            @Min(Constants.MIN_WIDTH)
            @Max(Constants.MAX_WIDTH)
            int width,
            @Parameter(description = "图片高度，最小值为 12，最大值为 1920", example = "200")
            @PathVariable
            @Min(Constants.MIN_HEIGHT)
            @Max(Constants.MAX_HEIGHT)
            int height,
            @Parameter(description = "图片文字，最小长度为 2，最大长度为 10", example = "Hello")
            @PathVariable
            @Size(min = Constants.MIN_TEXT_LENGTH, max = Constants.MAX_TEXT_LENGTH)
            String text,
            @Parameter(description = "字体名称，可选值为 Arial、Hei、Courier New", example = "Arial")
            @RequestParam(required = false, defaultValue = Constants.DEFAULT_FONT_NAME)
            @Pattern(regexp = Constants.FONT_NAME_REGEX)
            String fontName,
            @Parameter(description = "字体样式，可选值为 PLAIN、BOLD、ITALIC", example = "PLAIN")
            @RequestParam(required = false, defaultValue = Constants.DEFAULT_FONT_STYLE)
            FontStyle fontStyle,
            @Parameter(description = "字体大小，最小值为 12，最大值为 72", example = "12")
            @RequestParam(required = false, defaultValue = Constants.MIN_FONT_SIZE + "")
            @Min(Constants.MIN_FONT_SIZE)
            @Max(Constants.MAX_FONT_SIZE)
            int fontSize)
            throws IOException {
        return buildImage(width, height, text, parseHexToColor(Constants.DEFAULT_BACKGROUND_COLOR), parseHexToColor(Constants.DEFAULT_TEXT_COLOR), fontName, fontStyle.getValue(), fontSize);
    }

    @Operation(summary = "根据指定的宽度、高度、文字和背景颜色生成图片", description = "根据指定的宽度、高度、文字和背景颜色生成图片")
    @GetMapping("/{width}/{height}/{text}/{backgroundColor}")
    public ResponseEntity<byte[]> generateImage(
            @Parameter(description = "图片宽度，最小值为 12，最大值为 1920", example = "200")
            @PathVariable
            @Min(Constants.MIN_WIDTH)
            @Max(Constants.MAX_WIDTH)
            int width,
            @Parameter(description = "图片高度，最小值为 12，最大值为 1920", example = "200")
            @PathVariable
            @Min(Constants.MIN_HEIGHT)
            @Max(Constants.MAX_HEIGHT)
            int height,
            @Parameter(description = "图片文字，最小长度为 2，最大长度为 10", example = "Hello")
            @PathVariable
            @Size(min = Constants.MIN_TEXT_LENGTH, max = Constants.MAX_TEXT_LENGTH)
            String text,
            @Parameter(description = "图片背景颜色，16 进制颜色值，如 FFFFFF，注意字符串前面不需要写 #", example = "FFFFFF")
            @PathVariable
            @Pattern(regexp = Constants.HEX_COLOR_REGEX)
            String backgroundColor,
            @Parameter(description = "字体名称，可选值为 Arial、Hei、Courier New", example = "Arial")
            @RequestParam(required = false, defaultValue = Constants.DEFAULT_FONT_NAME)
            @Pattern(regexp = Constants.FONT_NAME_REGEX)
            String fontName,
            @Parameter(description = "字体样式，可选值为 PLAIN、BOLD、ITALIC", example = "PLAIN")
            @RequestParam(required = false, defaultValue = Constants.DEFAULT_FONT_STYLE)
            FontStyle fontStyle,
            @Parameter(description = "字体大小，最小值为 12，最大值为 72", example = "12")
            @RequestParam(required = false, defaultValue = Constants.MIN_FONT_SIZE + "")
            @Min(Constants.MIN_FONT_SIZE)
            @Max(Constants.MAX_FONT_SIZE)
            int fontSize)
            throws IOException {
        return buildImage(width, height, text, parseHexToColor(backgroundColor), parseHexToColor(Constants.DEFAULT_TEXT_COLOR), fontName,
                fontStyle.getValue(), fontSize);
    }

    @Operation(summary = "根据指定的宽度、高度、文字、背景颜色和文字颜色生成图片", description = "根据指定的宽度、高度、文字、背景颜色和文字颜色生成图片")
    @GetMapping("/{width}/{height}/{text}/{backgroundColor}/{textColor}")
    public ResponseEntity<byte[]> generateImage(
            @Parameter(description = "图片宽度，最小值为 12，最大值为 1920", example = "200")
            @PathVariable
            @Min(Constants.MIN_WIDTH)
            @Max(Constants.MAX_WIDTH)
            int width,
            @Parameter(description = "图片高度，最小值为 12，最大值为 1920", example = "200")
            @PathVariable
            @Min(Constants.MIN_HEIGHT)
            @Max(Constants.MAX_HEIGHT)
            int height,
            @Parameter(description = "图片文字，最小长度为 2，最大长度为 10", example = "Hello")
            @PathVariable
            @Size(min = Constants.MIN_TEXT_LENGTH, max = Constants.MAX_TEXT_LENGTH)
            String text,
            @Parameter(description = "图片背景颜色，16 进制颜色值，如 FFFFFF，注意字符串前面不需要写 #", example = "FFFFFF")
            @PathVariable
            @Pattern(regexp = Constants.HEX_COLOR_REGEX)
            String backgroundColor,
            @Parameter(description = "图片文字颜色，16 进制颜色值，如 FFFFFF，注意字符串前面不需要写 #", example = "FFFFFF")
            @PathVariable
            @Pattern(regexp = Constants.HEX_COLOR_REGEX)
            String textColor,
            @Parameter(description = "字体名称，可选值为 Arial、Hei、Courier New", example = "Arial")
            @RequestParam(required = false, defaultValue = Constants.DEFAULT_FONT_NAME)
            @Pattern(regexp = Constants.FONT_NAME_REGEX)
            String fontName,
            @Parameter(description = "字体样式，可选值为 PLAIN、BOLD、ITALIC", example = "PLAIN")
            @RequestParam(required = false, defaultValue = Constants.DEFAULT_FONT_STYLE)
            FontStyle fontStyle,
            @Parameter(description = "字体大小，最小值为 12，最大值为 72", example = "12")
            @RequestParam(required = false, defaultValue = Constants.MIN_FONT_SIZE  + "")
            @Min(Constants.MIN_FONT_SIZE)
            @Max(Constants.MAX_FONT_SIZE)
            int fontSize)
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
