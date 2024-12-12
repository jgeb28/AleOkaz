package pl.aleokaz.backend.user;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import pl.aleokaz.backend.user.login.*;

import java.util.Map;

@RestController
@RequestMapping("/api/users")
public class UserController {
    @Autowired
    private UserService userService;

    @PostMapping
    public ResponseEntity<UserDto> registerUser(@RequestBody RegisterCommand registerCommand) {
        return ResponseEntity.ok(userService.registerUser(registerCommand));
    }

    @PostMapping("/login")
    public ResponseEntity<LoginResponse> loginUser(@RequestBody LoginCommand loginCommand) {
        return ResponseEntity.ok(userService.loginUser(loginCommand));
    }

    @PostMapping("/refresh")
    public ResponseEntity<RefreshResponse> refreshUserToken(@RequestBody RefreshCommand refreshCommand) {
        return ResponseEntity.ok(userService.refreshUserToken(refreshCommand));
    }

}
