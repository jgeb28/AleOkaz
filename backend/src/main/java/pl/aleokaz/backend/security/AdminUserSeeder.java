package pl.aleokaz.backend.security;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.core.env.Environment;
import org.springframework.lang.NonNull;
import org.springframework.stereotype.Component;

import pl.aleokaz.backend.user.UserService;
import pl.aleokaz.backend.user.exceptions.UserExistsException;

@Component
public class AdminUserSeeder implements ApplicationListener<ContextRefreshedEvent> {
    private final static Logger LOGGER = LoggerFactory.getLogger(AdminUserSeeder.class);

    @Autowired
    private Environment environment;

    @Autowired
    private UserService userService;

    @Override
    public void onApplicationEvent(@NonNull ContextRefreshedEvent event) {
        final var email = environment.getProperty("aleokaz.admin.email");
        final var password = environment.getProperty("aleokaz.admin.password");

        if (email == null || password == null) {
            LOGGER.info("Aborting admin user seeding. " +
                    "Admin email and/or password is null. " +
                    "Set aleokaz.admin.{email,password} properties to create the user.");
            return;
        }

        try {
            userService.registerUser("admin", password.toCharArray());
        } catch (UserExistsException e) {
        }

        // TODO(michalciechan): Przypisać adminowi rolę ADMIN.
    }
}
