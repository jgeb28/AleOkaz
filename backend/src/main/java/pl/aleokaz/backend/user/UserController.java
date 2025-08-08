package pl.aleokaz.backend.user;

import java.net.URI;
import java.net.URISyntaxException;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;

import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import pl.aleokaz.backend.security.AuthenticationService;
import pl.aleokaz.backend.security.LoginResponse;
import pl.aleokaz.backend.security.RefreshResponse;
import pl.aleokaz.backend.user.commands.LoginCommand;
import pl.aleokaz.backend.user.commands.RefreshCommand;
import pl.aleokaz.backend.user.commands.RegisterCommand;
import pl.aleokaz.backend.user.commands.UpdateInfoCommand;

@RestController
@RequestMapping("/api/users")
public class UserController {
    @Autowired
    private AuthenticationService authenticationService;

    @Autowired
    private UserService userService;

    private final ObjectMapper objectMapper = new ObjectMapper();

    @GetMapping("/name/{username}")
    public ResponseEntity<UserDTO> findUserByUsername(@PathVariable String username) {
        User user = userService.getUserByUsername(username);
        if (user == null)
            return new ResponseEntity<>(HttpStatus.NO_CONTENT);
        return new ResponseEntity<>(user.asUserDTO(), HttpStatus.OK);
    }

    @PostMapping("/register")
    public ResponseEntity<UserDTO> registerUser(@RequestBody RegisterCommand registerCommand)
            throws URISyntaxException {
        User user = userService.registerUser(registerCommand.username(),
                registerCommand.password());
        if (user == null)
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        URI uri = ServletUriComponentsBuilder.fromCurrentRequest()
                .path("/{id}")
                .buildAndExpand(user.id())
                .toUri();
        return ResponseEntity.created(uri).body(user.asUserDTO());
    }

    @PostMapping("/login")
    public ResponseEntity<LoginResponse> loginUser(@RequestBody LoginCommand loginCommand) {
        LoginResponse loginResponse = userService.loginUser(loginCommand.username(), loginCommand.password());
        if (loginResponse == null)
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        return new ResponseEntity<>(loginResponse, HttpStatus.OK);
    }

    @PostMapping("/refresh")
    public ResponseEntity<RefreshResponse> refreshUserToken(@RequestBody RefreshCommand refreshCommand) {
        RefreshResponse refreshResponse = userService.refreshUserToken(refreshCommand.refreshToken());
        if (refreshResponse == null)
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        return new ResponseEntity<>(refreshResponse, HttpStatus.OK);
    }

    @GetMapping("/info/{id}")
    public ResponseEntity<UserDTO> getUserInfo(@PathVariable UUID id) {
        User user = userService.getUserById(id);
        if (user == null)
            return new ResponseEntity<>(HttpStatus.NO_CONTENT);
        return new ResponseEntity<>(user.asUserDTO(), HttpStatus.OK);
    }

    @GetMapping("/info")
    public ResponseEntity<UserDTO> getUserInfo(Authentication authentication) {
        UUID currentUserId = authenticationService.getCurrentUserId(authentication);
        User user = userService.getUserById(currentUserId);
        if (user == null)
            return new ResponseEntity<>(HttpStatus.NO_CONTENT);
        return new ResponseEntity<>(user.asUserDTO(), HttpStatus.OK);
    }

    @PutMapping(path="/info", consumes = "multipart/form-data")
    public ResponseEntity<UserDTO> updateUserInfo(
                Authentication authentication,
                @RequestPart("userInfo") String updateInfoCommand,
                @RequestPart(value = "image", required = false) MultipartFile image)
                throws JsonProcessingException, JsonMappingException {
        UUID currentUserId = authenticationService.getCurrentUserId(authentication);
        UpdateInfoCommand command = objectMapper.readValue(updateInfoCommand, UpdateInfoCommand.class);
        User user = userService.updateUserInfo(currentUserId, command, image);
        if (user == null)
            return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
        return new ResponseEntity<>(user.asUserDTO(), HttpStatus.OK);
    }
}