# Use official Tomcat 10 with JDK 17
FROM tomcat:10.1-jdk17

# Set working directory
WORKDIR /usr/local/tomcat

# Remove the default ROOT webapp
RUN rm -rf webapps/ROOT

# Copy your project’s JSP files into Tomcat ROOT
COPY src/main/webapp/ webapps/ROOT/

# Make sure WEB-INF is included properly
COPY src/main/webapp/WEB-INF webapps/ROOT/WEB-INF/

# Expose the default port
EXPOSE 8080

# Start Tomcat server
CMD ["catalina.sh", "run"]
