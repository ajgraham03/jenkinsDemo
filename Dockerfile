# Dockerfile for Calculator Java Application

# Multi-stage build for optimized image size
 
# Stage 1: Build stage with Maven

FROM --platform=linux/amd64 maven:3.9-eclipse-temurin-17-alpine AS builder
 
WORKDIR /app
 
# Copy pom.xml first to leverage Docker cache

COPY pom.xml .
 
# Download dependencies (cached if pom.xml unchanged)

RUN mvn dependency:go-offline -B
 
# Copy source code

COPY src ./src
 
# Build the application (compile, test, package)

RUN mvn clean package -B
 
# Stage 2: Runtime stage with JRE only

FROM --platform=linux/amd64 eclipse-temurin:17-jre-alpine
 
WORKDIR /app
 
# Create non-root user for security

RUN addgroup -S appgroup && adduser -S appuser -G appgroup
 
# Copy the JAR from builder stage

COPY --from=builder /app/target/calculator-app-*.jar app.jar
 
# Change ownership to non-root user

RUN chown -R appuser:appgroup /app
 
# Switch to non-root user

USER appuser
 
# Labels for container metadata

LABEL maintainer="Jenkins Demo"

LABEL version="1.0.0"

LABEL description="Calculator Demo Application for Jenkins CI/CD"
 
# Run the application

ENTRYPOINT ["java", "-jar", "app.jar"]
 