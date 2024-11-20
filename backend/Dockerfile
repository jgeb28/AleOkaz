FROM eclipse-temurin:21-jdk-jammy AS base
WORKDIR /build
COPY --chmod=0755 mvnw mvnw
COPY .mvn/ .mvn/

################################################################################

FROM base AS test
WORKDIR /build
COPY ./src src/
RUN --mount=type=bind,source=pom.xml,target=pom.xml \
    --mount=type=cache,target=/root/.m2 \
    ./mvnw test

################################################################################

FROM base AS dependencies

WORKDIR /build

COPY --chmod=0755 mvnw mvnw
COPY .mvn/ .mvn/

# Pobierz zależności teraz, żeby iteracyjne budowanie obrazu nie wymuszało
# ponownego ich pobierania, gdy `pom.xml` pozostaje niezmienione.
RUN --mount=type=bind,source=pom.xml,target=pom.xml \
    --mount=type=cache,target=/root/.m2 \
    ./mvnw dependency:go-offline -DskipTests

################################################################################

FROM dependencies AS package

WORKDIR /build

COPY ./src src/
RUN --mount=type=bind,source=pom.xml,target=pom.xml \
    --mount=type=cache,target=/root/.m2 \
    ./mvnw package -DskipTests && \
    ARTIFACT_ID=$(./mvnw help:evaluate -Dexpression=project.artifactId -q -DforceStdout) && \
    PROJECT_VERSION=$(./mvnw help:evaluate -Dexpression=project.version -q -DforceStdout) && \
    mv target/$ARTIFACT_ID-$PROJECT_VERSION.jar target/backend.jar

################################################################################

FROM package AS extract

WORKDIR /build

# Wyekstaktuj JAR za pomocą Sping Boot layer tools.
# https://docs.spring.io/spring-boot/docs/current/reference/html/container-images.html
RUN java -Djarmode=layertools -jar target/backend.jar extract --destination target/extracted

################################################################################

FROM eclipse-temurin:21-jre-jammy AS production

ARG UID=10001
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    aleokaz
USER aleokaz

COPY --from=extract build/target/extracted/dependencies/ ./
COPY --from=extract build/target/extracted/spring-boot-loader/ ./
COPY --from=extract build/target/extracted/snapshot-dependencies/ ./
COPY --from=extract build/target/extracted/application/ ./

EXPOSE 8080

ENTRYPOINT [ "java", "org.springframework.boot.loader.launch.JarLauncher" ]
