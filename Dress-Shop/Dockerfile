# Use official Tomcat 10 with JDK 17
FROM tomcat:10.1-jdk17

# Copy your already-built WAR file into Tomcat
COPY target/Dress-Shop.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
