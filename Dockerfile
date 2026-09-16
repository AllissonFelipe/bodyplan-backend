FROM eclipse-temurin:21-jdk-alpine AS build
WORKDIR /app
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .
COPY src src
RUN chmod +x mvnw \
  && ./mvnw -DskipTests package \
  && BOOT_JAR=$(ls target/bodyplan-api-*.jar | grep -v plain | head -n 1) \
  && cp "$BOOT_JAR" /app/application.jar

FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY --from=build /app/application.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
