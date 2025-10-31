# Use official Tomcat with JDK
FROM tomcat:10.1-jdk17

WORKDIR /usr/local/tomcat

# Remove default ROOT app
RUN rm -rf webapps/ROOT

# Copy source code
COPY src/main/webapp/ webapps/ROOT/
COPY src/main/java/ /tmp/java/

# Compile Java files into Tomcat classes folder
RUN mkdir -p webapps/ROOT/WEB-INF/classes && \
    javac -d webapps/ROOT/WEB-INF/classes $(find /tmp/java -name "*.java")

# Expose port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
