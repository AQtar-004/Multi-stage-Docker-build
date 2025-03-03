
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

