package com.mooc.backend.rest.app;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.result.MockMvcResultMatchers;


@WebMvcTest(ImageController.class)
@AutoConfigureMockMvc(addFilters = false)
public class ImageControllerTests {

    @Autowired
    private MockMvc mockMvc;

    @Test
    public void givenPath_whenGetImage_thenStatus200() throws Exception {
        mockMvc.perform(MockMvcRequestBuilders.get(
                "/api/v1/app/image/{width}", "100"))
                .andExpect(MockMvcResultMatchers.status().isOk())
                .andExpect(MockMvcResultMatchers
                        .header().string("Content-Type", "image/png"));
    }

    @Test
    public void givenWrongPath_whenGetImage_thenStatus404() throws Exception {
        mockMvc.perform(MockMvcRequestBuilders.get(
                "/api/v1/app/images/{width}", "100"))
                .andExpect(MockMvcResultMatchers.status().isNotFound());
    }

    @Test
    public void givenWrongParam_whenGetImage_thenStatus400() throws Exception {
        mockMvc.perform(MockMvcRequestBuilders.get(
                "/api/v1/app/image/{width}", "abc"))
                .andExpect(MockMvcResultMatchers.status().isBadRequest());
    }
}
