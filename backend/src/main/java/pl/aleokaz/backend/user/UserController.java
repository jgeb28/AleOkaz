package pl.aleokaz.backend.user;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/api/users")
public class UserController {
    @Autowired
    private UserService userService;

    @PostMapping
    public ResponseEntity<UserDto> registerUser(@RequestBody RegisterCommand registerCommand) {
        return ResponseEntity.ok(userService.registerUser(registerCommand));
    }

    @PreAuthorize("permitAll()")
    @PostMapping("/login")
    public ResponseEntity<LoginResponse> loginUser(@RequestBody LoginCommand loginCommand) {
        return ResponseEntity.ok(userService.loginUser(loginCommand));
    }

    @PreAuthorize("permitAll()")
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
