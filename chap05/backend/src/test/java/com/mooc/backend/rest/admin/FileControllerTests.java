package com.mooc.backend.rest.admin;

import com.mooc.backend.config.QiniuProperties;
import com.mooc.backend.services.QiniuService;
import com.qiniu.storage.model.FileInfo;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.context.annotation.Import;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.result.MockMvcResultMatchers;

import java.util.List;

@Import(QiniuProperties.class)
@WebMvcTest(FileController.class)
public class FileControllerTests {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private QiniuService qiniuService;

    @Test
    public void givenPath_whenListFiles_thenStatus200() throws Exception {
        var fileInfo = new FileInfo();
        fileInfo.key = "test";
        var list = List.of(fileInfo);
        Mockito.when(qiniuService.list(
                Mockito.anyString(), Mockito.anyString(), Mockito.anyInt()))
                .thenReturn(list);

        mockMvc.perform(MockMvcRequestBuilders.get(
                "/api/v1/admin/files" ))
                .andExpect(MockMvcResultMatchers.status().isOk())
                .andExpect(MockMvcResultMatchers
                        .jsonPath("$[0].key")
                        .value("test"));
    }
}
