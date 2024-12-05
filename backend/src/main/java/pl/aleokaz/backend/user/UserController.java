package pl.aleokaz.backend.user;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

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
        System.out.println(loginCommand.username());
        System.out.println(loginCommand.password());
        return ResponseEntity.ok(userService.loginUser(loginCommand));
    }

    @PostMapping("/validate")
    public ResponseEntity<Boolean> validateToken(@RequestBody TokenCommand tokenCommand) {
        System.out.println(tokenCommand.token());
        return ResponseEntity.ok(userService.validateToken(tokenCommand));
    }

}
