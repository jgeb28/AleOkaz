package pl.aleokaz.backend.user;

import java.net.URISyntaxException;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

// TODO(michalciechan): Obsługa wyjątków.
@RestController
@RequestMapping("/api/users")
public class UserController {
    @Autowired
    private UserService userService;

    @GetMapping("/{id}")
    public ResponseEntity<UserDto> findUserById(@PathVariable UUID id) {
        return ResponseEntity.ok(userService.findUserById(id));
    }

    @PostMapping
    public ResponseEntity<UserDto> registerUser(@RequestBody RegisterCommand registerCommand)
            throws URISyntaxException {
        final var user = userService.registerUser(registerCommand);
        final var uri = ServletUriComponentsBuilder.fromCurrentRequest()
                .path("/{id}")
                .buildAndExpand(user.id())
                .toUri();
        return ResponseEntity.created(uri).body(user);
    }

    @PostMapping("/login")
    public ResponseEntity<LoginResponse> loginUser(@RequestBody LoginCommand loginCommand) {
        return ResponseEntity.ok(userService.loginUser(loginCommand));
    }

    @PostMapping("/refresh")
    public ResponseEntity<RefreshResponse> refreshUserToken(@RequestBody RefreshCommand refreshCommand) {
        return ResponseEntity.ok(userService.refreshUserToken(refreshCommand));
    }

    //przykładowy endpoint wymagający autoryzacji w nagłówku "Bearer token"
    @GetMapping("/info/{id}")
    public ResponseEntity<UserDto> getUserInfo(@PathVariable UUID id, Authentication authentication) {
        String currentUserId = (String) authentication.getPrincipal();

        if (!currentUserId.equals(id.toString())) {
            throw new RuntimeException("Access denied: You can only access your own info.");
        }

        return ResponseEntity.ok(userService.getUserInfo(id));
    }

}
