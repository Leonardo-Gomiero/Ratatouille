FROM maven:3.8.7-eclipse-temurin-8-alpine AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the pom.xml first to leverage Docker cache for dependencies
COPY pom.xml .

# Install dependencies without building the app
RUN mvn dependency:go-offline

# Copy the source code
COPY src ./src

# Build the application
RUN mvn clean install

# Use a lightweight OpenJDK image for running the application
FROM openjdk:21-jdk-slim

# Set the working directory in the final container
WORKDIR /app

# Copy the jar file from the build stage
COPY --from=build /app/target/*.jar app.jar

# Expose the application on port 8080
EXPOSE 8080

# Command to run the application
CMD ["mvn", "spring-boot:run"]