# Use the official Tomcat 10 image with JDK 17 (matching your server setup)
FROM tomcat:10.1-jdk17-openjdk-slim

# Clear out the default Tomcat webapps for a clean slate
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the built WAR file from Maven's target folder into the Tomcat webapps folder
# (Assuming your Maven build generates a .war file)
COPY target/*.war /usr/local/tomcat/webapps/ROOT.war

# Expose port 8080
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
