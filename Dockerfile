# Stage 1: Build the application
FROM maven:3.9.11-amazoncorretto-21 AS build
ARG MVN_OPTIONS
WORKDIR /app

COPY pom.xml .
COPY src ./src 

RUN mvn clean package $MVN_OPTIONS

# Stage 2: Create the runtime image
FROM alpine/java:21-jre

WORKDIR /app
COPY --from=build /app/target/spring-petclinic-3.5.0-SNAPSHOT.jar ./petclinic.jar

EXPOSE 8080

CMD ["java", "-jar", "petclinic.jar"]
