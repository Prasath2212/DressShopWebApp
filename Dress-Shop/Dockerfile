# Use Maven to build the project
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# Use Tomcat to serve the built app
FROM tomcat:10.1-jdk17
WORKDIR /usr/local/tomcat/webapps/ROOT

# Copy the compiled web app (JSPs, WEB-INF, etc.)
COPY src/main/webapp/ ./
COPY target/classes ./WEB-INF/classes

EXPOSE 8080
CMD ["catalina.sh", "run"]
