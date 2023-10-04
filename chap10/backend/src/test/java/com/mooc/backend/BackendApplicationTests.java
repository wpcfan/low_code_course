package com.mooc.backend;

import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.annotation.DirtiesContext;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.TestPropertySource;
import org.testcontainers.containers.GenericContainer;
import org.testcontainers.containers.MySQLContainer;
import org.testcontainers.utility.DockerImageName;

@ActiveProfiles("test")
@DirtiesContext(classMode = DirtiesContext.ClassMode.AFTER_CLASS)
@TestPropertySource(properties = {
        "spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQLDialect",
        "spring.jpa.properties.hibernate.cache.use_structured_entries=true",
        "spring.jpa.properties.hibernate.cache.use_query_cache=true",
        "spring.jpa.properties.hibernate.cache.use_second_level_cache=true",
        "spring.jpa.properties.hibernate.cache.region.factory_class=org.redisson.hibernate.RedissonRegionFactory",
        "spring.redis.redisson.file=classpath:redisson.yaml"
})
@SpringBootTest
class BackendApplicationTests {

    @BeforeAll
    static void init() {
        GenericContainer<?> redis = new GenericContainer<>(DockerImageName.parse("redis:7-alpine"))
                .withExposedPorts(6379);
        redis.start();
        System.setProperty("REDIS_URL", "redis://" + redis.getHost() + ":" + redis.getFirstMappedPort());

        MySQLContainer<?> mysql = new MySQLContainer<>("mysql:8")
                .withDatabaseName("low_code")
                .withUsername("user")
                .withPassword("password");
        mysql.start();
        System.setProperty("SPRING_DATASOURCE_URL", "jdbc:mysql://" + mysql.getHost() + ":" + mysql.getFirstMappedPort() + "/low_code?useUnicode=true&characterEncoding=utf-8&useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true");
        System.setProperty("SPRING_DATASOURCE_USERNAME", "user");
        System.setProperty("SPRING_DATASOURCE_PASSWORD", "password");
        System.setProperty("SPRING_DATASOURCE_DRIVER_CLASS_NAME", "com.mysql.cj.jdbc.Driver");
    }

    @AfterAll
    static void destroy() {
        System.clearProperty("REDIS_URL");
        System.clearProperty("SPRING_DATASOURCE_URL");
        System.clearProperty("SPRING_DATASOURCE_USERNAME");
        System.clearProperty("SPRING_DATASOURCE_PASSWORD");
        System.clearProperty("SPRING_DATASOURCE_DRIVER_CLASS_NAME");
    }

    @Test
    void contextLoads() {
    }


}
