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

    public ImageService(Environment environment) {
        this.environment = environment;
        imageUploadDir = this.environment.getProperty("aleokaz.image.upload.dir");
    }

    public String saveImage(MultipartFile image) throws IOException {
        File directory = new File(imageUploadDir);
        if (!directory.exists()) {
            directory.mkdirs();
        }

        String filename = UUID.randomUUID() + "-" + image.getOriginalFilename();
        Path filePath = Paths.get(imageUploadDir, filename); // Correct way to join paths

        Files.copy(image.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);

        return "/uploads/" + filename;
    }
}
