# Use Tomcat 10 + JDK 17
FROM tomcat:10.1-jdk17

WORKDIR /usr/local/tomcat

# Remove default ROOT app
RUN rm -rf webapps/ROOT

# Copy JSPs, WEB-INF (including your .jar files)
COPY src/main/webapp/ webapps/ROOT/

# Copy Java source files
COPY src/main/java/ /tmp/java/

# Compile servlets
RUN mkdir -p webapps/ROOT/WEB-INF/classes && \
    javac -cp "/usr/local/tomcat/lib/*:webapps/ROOT/WEB-INF/lib/*" \
         -d webapps/ROOT/WEB-INF/classes \
         $(find /tmp/java -name "*.java")

EXPOSE 8080
CMD ["catalina.sh", "run"]
