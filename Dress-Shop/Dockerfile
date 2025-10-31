# Use official Tomcat 10 with JDK 17
FROM tomcat:10.1-jdk17

# Remove default ROOT webapp
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy your JSP project into Tomcat webapps
COPY src/main/webapp/ /usr/local/tomcat/webapps/ROOT/

# Expose the default Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
