package com.mooc.backend.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class SwaggerConfig {
    @Bean
    public OpenAPI springShopOpenAPI() {
        var info = new Info()
                .title("动态页面运营管理平台 API 文档")
                .description("这个 API 文档提供了后台管理和前端 APP 所需的接口")
                .termsOfService("")
                .license(new License().name("Apache").url(""))
                .version("0.0.1");
        var httpBasicSecurityItem = new io.swagger.v3.oas.models.security.SecurityScheme()
                .type(io.swagger.v3.oas.models.security.SecurityScheme.Type.HTTP)
                .scheme("basic");
        var jwtSecurityItem = new io.swagger.v3.oas.models.security.SecurityScheme()
                .type(io.swagger.v3.oas.models.security.SecurityScheme.Type.HTTP)
                .scheme("bearer")
                .bearerFormat("JWT");
        var securityComponent = new io.swagger.v3.oas.models.Components()
                .addSecuritySchemes("bearerAuth", jwtSecurityItem)
                .addSecuritySchemes("basicAuth", httpBasicSecurityItem);

        return new OpenAPI()
                .components(securityComponent)
                .addSecurityItem(new io.swagger.v3.oas.models.security.SecurityRequirement().addList("bearerAuth"))
                .info(info);
    }
}
