# Use official Tomcat 10 with JDK 17
FROM tomcat:10.1-jdk17

# Set working directory
WORKDIR /usr/local/tomcat

# Remove default ROOT webapp
RUN rm -rf webapps/ROOT

# Copy JSP and assets
COPY src/main/webapp/ webapps/ROOT/

# Copy compiled servlet classes (from Eclipse build output)
COPY build/classes/ webapps/ROOT/WEB-INF/classes/

# Expose default port
EXPOSE 8080

# Start Tomcat server
CMD ["catalina.sh", "run"]
