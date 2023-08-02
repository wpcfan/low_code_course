package com.mooc.backend.rest;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/image")
public class ImageController {

    @GetMapping("/{width}")
    public String generateImage(@PathVariable int width) {
        return "Image width: " + width + "px";
    }
}
