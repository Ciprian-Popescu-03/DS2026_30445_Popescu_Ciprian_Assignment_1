FROM maven:3.9-eclipse-temurin-8 AS builder
WORKDIR /build

COPY pom.xml checkstyle.xml ./
RUN mvn -B dependency:go-offline

COPY src ./src
RUN mvn -B package -DskipTests


FROM eclipse-temurin:8-jre
WORKDIR /app

RUN groupadd --system spring && useradd --system --gid spring spring

COPY --from=builder /build/target/*.jar app.jar

USER spring
ENV TZ=UTC
EXPOSE 8080

ENTRYPOINT ["java", "-XX:MaxRAMPercentage=75.0", "-jar", "app.jar"]