package pl.aleokaz.backend.user;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

import pl.aleokaz.backend.PostgreSqlTestContainerInitializer;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.web.servlet.MockMvc;

@SpringBootTest
@AutoConfigureMockMvc
@ExtendWith(PostgreSqlTestContainerInitializer.class)
@ContextConfiguration(initializers = PostgreSqlTestContainerInitializer.class)
public class UserControllerIT {
    @Autowired
    MockMvc mockMvc;

    @Test
    public void shouldRegisterUser() throws Exception {
        final var request = """
                {
                    "username": "user",
                    "email": "user@example.com",
                    "password": "password"
                }
                """;
        final var response = """
                {
                    "username": "user",
                    "email": "user@example.com"
                }
                """;
        mockMvc.perform(
                post("/api/users")
                        .contentType("application/json")
                        .content(request))
                .andExpect(status().isCreated())
                .andExpect(content().json(response));
    }

    @Test
    public void shouldNotRegisterUserWhenRequiredFieldsAreMissing() throws Exception {
        var content = """
                {
                    "email": "user@example.com",
                    "password": "password"
                }
                """;
        mockMvc.perform(
                post("/api/users")
                        .contentType("application/json")
                        .content(content))
                .andExpect(status().isBadRequest());

        content = """
                {
                    "username": "user",
                    "password": "password"
                }
                """;
        mockMvc.perform(
                post("/api/users")
                        .contentType("application/json")
                        .content(content))
                .andExpect(status().isBadRequest());

        content = """
                {
                    "username": "user",
                    "email": "user@example.com"
                }
                """;
        mockMvc.perform(
                post("/api/users")
                        .contentType("application/json")
                        .content(content))
                .andExpect(status().isBadRequest());
    }
}
