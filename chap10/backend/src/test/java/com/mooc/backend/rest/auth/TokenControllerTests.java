package com.mooc.backend.rest.auth;

import com.mooc.backend.config.SecurityConfig;
import com.mooc.backend.repositories.PageLayoutRepository;
import com.mooc.backend.rest.admin.PlaygroundController;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.context.annotation.Import;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.jwt.JwtEncoder;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;
import org.springframework.test.web.servlet.MockMvc;

import java.time.Instant;
import java.util.Collection;

import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.authentication;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.httpBasic;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@Import(SecurityConfig.class)
@WebMvcTest({
        TokenController.class,
        PlaygroundController.class
})
@AutoConfigureMockMvc(printOnlyOnFailure = false)
public class TokenControllerTests {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private JwtEncoder jwtEncoder;

    @MockBean
    private PageLayoutRepository pageLayoutRepository;

    @Test
    public void givenCorrectPassword_whenGetToken_thenStatus200() throws Exception {
        Jwt jwt = Jwt.withTokenValue("token")
                .header("alg", "none")
                .claim("sub", "user")
                .build();
        Mockito.when(jwtEncoder.encode(
                Mockito.any()
        )).thenReturn(jwt);
        // using Http Basic Auth
        mockMvc.perform(
                post("/api/v1/auth/token")
                        .with(httpBasic("admin", "admin"))
                )
                .andExpect(status().isOk());
    }

    @Test
    public void givenWrongPassword_whenGetToken_thenStatus401() throws Exception {
        mockMvc.perform(
                post("/api/v1/auth/token")
                        .with(httpBasic("admin", "wrong"))
                )
                .andExpect(status().isUnauthorized());
    }

    @Test
    public void givenJwtToken_whenAccessGetLayouts_thenStatus200() throws Exception {
        var now = Instant.now();
        var jwt = Jwt.withTokenValue("token")
                .subject("admin")
                .header("alg", "none")
                .issuedAt(now)
                .expiresAt(now.plusSeconds(3600))
                .issuer("self")
                .claim("scope", "SCOPE_ADMIN")
                .build();
        Collection<GrantedAuthority> authorities = AuthorityUtils.createAuthorityList("SCOPE_ADMIN");
        JwtAuthenticationToken token = new JwtAuthenticationToken(jwt, authorities);
        mockMvc.perform(
                get("/api/v1/admin/playground/top?platform={platform}", "APP")
                        .with(authentication(token))
                )
                .andExpect(status().isOk());
    }

    @Test
    public void givenNoJwtToken_whenAccessGetLayouts_thenStatus401() throws Exception {
        mockMvc.perform(
                get("/api/v1/admin/playground/top?platform={platform}", "APP")
                )
                .andExpect(status().isUnauthorized());
    }
}
