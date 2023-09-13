# Use the official Tomcat base image from Docker Hub
FROM tomcat:latest

# Remove the default ROOT application
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy your WAR file or web application into the webapps directory
# COPY app.war /usr/local/tomcat/webapps/ROOT.war

# Expose the default Tomcat port (8080)
EXPOSE 8080

# Start Tomcat when the container runs
CMD ["catalina.sh", "run"]
