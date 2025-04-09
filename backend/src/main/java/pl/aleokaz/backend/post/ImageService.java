package pl.aleokaz.backend.post;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

@Service
public class ImageService {

    private Environment environment;
    private final String imageUploadDir;
    private final String domainUrl;
    private final String profilePictureUploadDir;

    public ImageService(Environment environment) {
        this.environment = environment;
        imageUploadDir = this.environment.getProperty("aleokaz.image.upload.dir");
        domainUrl = this.environment.getProperty("aleokaz.base.url");
        profilePictureUploadDir = this.environment.getProperty("aleokaz.profile.picture.upload.dir");
    }

    public String saveImage(MultipartFile image) throws IOException {
        File directory = new File(imageUploadDir);
        if (!directory.exists()) {
            directory.mkdirs();
        }

        String filename = UUID.randomUUID() + "-" + image.getOriginalFilename();
        Path filePath = Paths.get(imageUploadDir, filename);

        Files.copy(image.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);

        return domainUrl + "/images/" + filename;
    }

    public String saveProfilePicture(MultipartFile profilePicture) throws IOException {
        File directory = new File(profilePictureUploadDir);
        if (!directory.exists()) {
            directory.mkdirs();
        }

        String filename = UUID.randomUUID() + "-" + profilePicture.getOriginalFilename();
        Path filePath = Paths.get(profilePictureUploadDir, filename);

        Files.copy(profilePicture.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);

        return domainUrl + "/profilePicture/" + filename;
    }
}
