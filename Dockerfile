FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Create a non-root user
RUN addgroup -S app && adduser -S app -G app

# Copy the application JAR file that was built and tested in the Jenkins pipeline
COPY target/*.jar app.jar

# Set permissions for the non-root user
RUN chown app:app app.jar

# Switch to the non-root user
USER app

# Expose the application port
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
