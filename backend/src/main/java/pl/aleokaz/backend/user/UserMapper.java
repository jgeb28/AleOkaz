package pl.aleokaz.backend.user;

import org.springframework.stereotype.Service;

import lombok.NonNull;

@Service
class UserMapper {
    public UserDto convertUserToUserDto(@NonNull User user) {
        return UserDto.builder()
                .id(user.id())
                .username(user.username())
                .email(user.email())
                .build();
    }
}
