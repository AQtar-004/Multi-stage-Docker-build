# Multi-stage-Docker-build

A multi-stage Docker build allows you to create smaller, more efficient Docker images by breaking down the build process into multiple stages. Each stage can have its own base image and build environment, which helps reduce the final image size by copying only the necessary artifacts from previous stages. This approach is beneficial for reducing the size of production containers by not including the entire build environment.
For a Maven and Tomcat deployment of a WAR file, you can use a multi-stage Docker build that involves two stages:
Build Stage: Use a Maven image to build the WAR file.
Deployment Stage: Use a Tomcat image to deploy the WAR file.
Here’s an example Dockerfile for a multi-stage build:
dockerfile

# Stage 1: Build stage using Maven
FROM maven:3.8.4-openjdk-11 AS builder

# Set the working directory in the container
WORKDIR /app

# Copy the pom.xml and any other required Maven configuration files
COPY pom.xml ./

# Download dependencies
RUN mvn dependency:go-offline -B

# Copy the project source
COPY src ./src

# Build the project and package it as a WAR file
RUN mvn clean package -DskipTests

# Stage 2: Deployment stage using Tomcat
FROM tomcat:9.0.53-jdk11-openjdk

# Set the working directory for the deployment
WORKDIR /usr/local/tomcat/webapps/

# Copy the WAR file from the Maven build stage
COPY --from=builder /app/target/*.war ./ROOT.war

# Expose port 8080 for Tomcat
EXPOSE 8080

# Start Tomcat server
CMD ["catalina.sh", "run"]

Key Points:
Stage 1 (builder): Uses a Maven image to build the WAR file from your source code.
The COPY command copies pom.xml and source code into the container.
Maven builds the project and creates the WAR file.
Stage 2: Uses a Tomcat image to deploy the WAR.
The COPY --from=builder command copies the WAR file from the first stage into the Tomcat webapps directory.
Exposes port 8080 for accessing the Tomcat application.
The CMD starts the Tomcat server.
