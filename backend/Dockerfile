FROM openjdk:21-jdk-slim
WORKDIR /app
COPY ./src ./src 
COPY ./mvnw ./mvnw
COPY ./.mvn ./.mvn
COPY ./pom.xml ./pom.xml
COPY ./lombok.config ./lombok.config
COPY ./.env ./.env
COPY ./uploads ./uploads
RUN ./mvnw clean package -DskipTests
EXPOSE 8080
CMD ["java", "-jar", "target/backend-0.0.1-SNAPSHOT.jar"]