package pl.aleokaz.backend.user;

import org.springframework.stereotype.Service;

@Service
class UserMapper {
    public UserDto convertUserToUserDto(User user) {
        return UserDto.builder()
                .id(user.id())
                .username(user.username())
                .email(user.email())
                .build();
    }
}
