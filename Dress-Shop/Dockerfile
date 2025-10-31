# Use Tomcat with Java 17
FROM tomcat:9.0-jdk17-temurin

# Remove default ROOT webapp
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy your JSP project into Tomcat webapps
COPY ./WebContent /usr/local/tomcat/webapps/ROOT

# Copy compiled classes (if you have /src folder with servlets)
COPY ./src /usr/local/tomcat/webapps/ROOT/WEB-INF/classes

# Expose Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
