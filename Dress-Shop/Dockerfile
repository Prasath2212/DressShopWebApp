# Use official Tomcat image with JDK 17
FROM tomcat:9.0-jdk17-temurin

# Remove the default ROOT webapp from Tomcat
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy your generated WAR file into Tomcat's webapps directory
COPY target/*.war /usr/local/tomcat/webapps/ROOT.war

# Expose port 8080 (Render will automatically map this)
EXPOSE 8080

# Start Tomcat server
CMD ["catalina.sh", "run"]
