
# Use an official Maven image to build the project
FROM maven:3.9-sapmachine-17 AS build

# Set the working directory
WORKDIR /app

# Copy the pom.xml and any other necessary files
COPY pom.xml /app/

# Download dependencies (this step will be cached by Docker)
RUN mvn dependency:go-offline

# Copy the rest of the application source code
COPY src /app/src

# Build the application
RUN mvn clean package

# Use a lightweight JDK image to run the application
FROM openjdk:17-jdk-alpine

# Set the working directory
WORKDIR /app

# Copy the jar file from the build stage
COPY --from=build /app/target/develops-project-0.0.1-SNAPSHOT.jar /app/develops-project-0.0.1-SNAPSHOT.jar

# Make port 4000 available to the world outside this container
EXPOSE 4000

# Run the JAR file
ENTRYPOINT ["java", "-jar", "/app/develops-project-0.0.1-SNAPSHOT.jar"]

