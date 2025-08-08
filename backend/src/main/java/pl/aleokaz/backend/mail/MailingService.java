package pl.aleokaz.backend.mail;

import org.springframework.stereotype.Service;

import io.micrometer.common.lang.NonNull;

@Service
public class MailingService {
    public void sendEmail(@NonNull String email, @NonNull String subject, @NonNull String message) {
        System.out.println("Email sent to: " + email + " with subject: " + subject + " and message: " + message);
        // TODO(marcin): implement sending email
    }
}