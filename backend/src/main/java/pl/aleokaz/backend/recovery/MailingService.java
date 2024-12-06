package pl.aleokaz.backend.recovery;

import io.micrometer.common.lang.NonNull;
import lombok.Builder;

public class MailingService {
    @NonNull
    private String email;

    @NonNull
    private String subject;

    @NonNull
    private String message;

    @Builder
    public MailingService(String email, String subject, String message) {
        this.email = email;
        this.subject = subject;
        this.message = message;
    }

    public void sendEmail() {
        System.out.println("Email sent to: " + email + " with subject: " + subject + " and message: " + message);
        // TODO(marcin): implement sending email
    }
}