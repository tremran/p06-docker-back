FROM eclipse-temurin:21-jdk AS build

WORKDIR /workspace

# Copier le projet puis generer le WAR via Gradle Wrapper
COPY . .
RUN chmod +x ./gradlew
RUN ./gradlew --no-daemon clean bootWar

FROM eclipse-temurin:21-jre

WORKDIR /app

COPY --from=build /workspace/build/libs/*.war /app/app.war

EXPOSE 8080

CMD ["java", "-jar", "/app/app.war"]