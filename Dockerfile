# Stage 1: Build the application
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app

# Copy the pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline || true

# Copy the source code and build the WAR
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Serve the application with Tomcat
FROM tomcat:10.1-jdk21

# Remove default Tomcat applications
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the built WAR file from the previous stage as ROOT.war 
# (This makes it accessible at the root URL '/' instead of '/ROOT')
COPY --from=build /app/target/ROOT.war /usr/local/tomcat/webapps/ROOT.war

# Expose port 8080 (Railway routes to this port automatically)
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
