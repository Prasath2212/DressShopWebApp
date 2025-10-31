# Use Tomcat 10 + JDK 17
FROM tomcat:10.1-jdk17

WORKDIR /usr/local/tomcat

# Remove default ROOT app
RUN rm -rf webapps/ROOT

# Copy JSPs and WEB-INF files
COPY src/main/webapp/ webapps/ROOT/

# Copy Java source files
COPY src/main/java/ /tmp/java/

# Copy local dependencies (Gson, MySQL, etc.)
# Make sure you have them inside a 'lib' folder in your project
COPY lib/*.jar /usr/local/tomcat/lib/

# Compile your servlets and Java classes
RUN mkdir -p webapps/ROOT/WEB-INF/classes && \
    javac -cp "/usr/local/tomcat/lib/*" \
          -d webapps/ROOT/WEB-INF/classes \
          $(find /tmp/java -name "*.java")

# Expose default Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
