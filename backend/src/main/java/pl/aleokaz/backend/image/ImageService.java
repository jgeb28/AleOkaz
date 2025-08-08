package pl.aleokaz.backend.image;

import org.springframework.core.env.Environment;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import pl.aleokaz.backend.image.exceptions.ImageSaveException;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

//TODO: rework
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

        String filename = UUID.randomUUID() + ".jpg";
        Path filePath = Paths.get(imageUploadDir, filename);

        BufferedImage bufferedImage = ImageIO.read(image.getInputStream());

        if (bufferedImage == null) {
            throw new IOException("Invalid image file");
        }

        BufferedImage rgbImage = new BufferedImage(bufferedImage.getWidth(), bufferedImage.getHeight(),
                BufferedImage.TYPE_INT_RGB);

        Graphics2D graphics = rgbImage.createGraphics();
        try {
            graphics.drawImage(bufferedImage, 0, 0, Color.WHITE, null);
        } finally {
            graphics.dispose();
        }

        boolean writeSuccess = ImageIO.write(rgbImage, "jpg", filePath.toFile());
        if (!writeSuccess) {
            throw new ImageSaveException();
        }

        return domainUrl + "/images/" + filename;
    }

    public String saveProfilePicture(MultipartFile profilePicture) throws IOException {
        File directory = new File(profilePictureUploadDir);
        if (!directory.exists()) {
            directory.mkdirs();
        }

        String filename = UUID.randomUUID() + ".jpg";
        Path filePath = Paths.get(profilePictureUploadDir, filename);

        BufferedImage originalImage = ImageIO.read(profilePicture.getInputStream());

        if (originalImage == null) {
            throw new IOException("Unsupported or corrupt image format.");
        }

        BufferedImage rgbImage = new BufferedImage(
                originalImage.getWidth(),
                originalImage.getHeight(),
                BufferedImage.TYPE_INT_RGB);

        Graphics2D graphics = (Graphics2D) rgbImage.getGraphics();
        try {
            graphics.drawImage(originalImage, 0, 0, Color.WHITE, null);
        } finally {
            graphics.dispose();
        }

        boolean writeSuccess = ImageIO.write(rgbImage, "jpg", filePath.toFile());
        if (!writeSuccess) {
            throw new IOException("Failed to save image as JPG.");
        }

        return domainUrl + "/profile_pictures/" + filename;
    }

}
