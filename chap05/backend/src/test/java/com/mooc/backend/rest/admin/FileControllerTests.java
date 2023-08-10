package com.mooc.backend.rest.admin;

import java.util.List;

import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.context.annotation.Import;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.result.MockMvcResultMatchers;

import com.mooc.backend.config.QiniuProperties;
import com.mooc.backend.services.QiniuService;
import com.qiniu.storage.model.DefaultPutRet;
import com.qiniu.storage.model.FileInfo;

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
                "/api/v1/admin/files"))
                .andExpect(MockMvcResultMatchers.status().isOk())
                .andExpect(MockMvcResultMatchers
                        .jsonPath("$[0].key")
                        .value("test"));
    }

    @Test
    public void givenPath_whenDeleteFile_thenStatus200() throws Exception {
        Mockito.doNothing().when(qiniuService).delete(Mockito.anyString());

        mockMvc.perform(MockMvcRequestBuilders.delete(
                "/api/v1/admin/files/test"))
                .andExpect(MockMvcResultMatchers.status().isOk());
    }

    @Test
    public void givenPath_whenDeleteFiles_thenStatus200() throws Exception {
        Mockito.doNothing().when(qiniuService).delete(Mockito.anyList());

        mockMvc.perform(MockMvcRequestBuilders.post(
                "/api/v1/admin/files/batch-delete")
                .contentType("application/json")
                .content("[\"test1\", \"test2\"]"))
                .andExpect(MockMvcResultMatchers.status().isOk());
    }

    @Test
    public void givenFile_whenUploadFile_thenStatus200() throws Exception {
        var ret = new DefaultPutRet();
        ret.key = "test";
        Mockito.when(qiniuService.upload(Mockito.any(), Mockito.anyString()))
                .thenReturn(ret);

        mockMvc.perform(MockMvcRequestBuilders.multipart(
                "/api/v1/admin/file")
                .file("file", "test".getBytes())
                .contentType("multipart/form-data"))
                .andExpect(MockMvcResultMatchers.status().isOk())
                .andExpect(MockMvcResultMatchers
                        .jsonPath("$.key")
                        .value("test"));
    }

    @Test
    public void givenFiles_whenUploadFiles_thenStatus200() throws Exception {
        var ret = new DefaultPutRet();
        ret.key = "test";
        Mockito.when(qiniuService.upload(Mockito.any(), Mockito.anyString()))
                .thenReturn(ret);

        mockMvc.perform(MockMvcRequestBuilders.multipart(
                "/api/v1/admin/files")
                .file("files", "test".getBytes())
                .contentType("multipart/form-data"))
                .andExpect(MockMvcResultMatchers.status().isOk())
                .andExpect(MockMvcResultMatchers
                        .jsonPath("$[0].key")
                        .value("test"));
    }
}
