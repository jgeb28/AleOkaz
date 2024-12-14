package pl.aleokaz.backend;

import org.junit.jupiter.api.extension.AfterAllCallback;
import org.junit.jupiter.api.extension.ExtensionContext;
import org.springframework.context.ApplicationContextInitializer;
import org.springframework.context.ConfigurableApplicationContext;
import org.testcontainers.containers.PostgreSQLContainer;

public class PostgreSqlTestContainerInitializer
        implements ApplicationContextInitializer<ConfigurableApplicationContext>, AfterAllCallback {
    private final static PostgreSQLContainer container = new PostgreSQLContainer("postgres:17")
            .withDatabaseName("postgres")
            .withUsername("postgres")
            .withPassword("postgres");

    @Override
    public void initialize(ConfigurableApplicationContext applicationContext) {
        container.start();
        System.setProperty("DATABASE_URL", container.getJdbcUrl());
        System.setProperty("DATABASE_USER", container.getUsername());
        System.setProperty("DATABASE_PASSWORD", container.getUsername());
    }

    @Override
    public void afterAll(ExtensionContext extensionContext) throws Exception {
        if (container == null) {
            return;
        }

        container.stop();
    }
}
