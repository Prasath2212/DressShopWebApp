# Use Tomcat with JDK 17
FROM tomcat:10.1-jdk17

WORKDIR /usr/local/tomcat

# Remove default ROOT webapp
RUN rm -rf webapps/ROOT

# Copy JSPs, HTML, etc.
COPY src/main/webapp/ webapps/ROOT/

# Copy Java source files
COPY src/main/java/ /tmp/java/

# Compile servlets and classes with Tomcat's servlet-api.jar on classpath
RUN mkdir -p webapps/ROOT/WEB-INF/classes && \
    javac -cp /usr/local/tomcat/lib/servlet-api.jar \
          -d webapps/ROOT/WEB-INF/classes \
          $(find /tmp/java -name "*.java")

# Copy any required libraries (like MySQL connector)
COPY lib/*.jar webapps/ROOT/WEB-INF/lib/

# Expose port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
