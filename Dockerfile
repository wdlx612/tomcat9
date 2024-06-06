# Use Ubuntu as the base image
FROM ubuntu:22.04

# Install necessary packages
RUN apt-get update && \
    apt-get install -y wget && \
    apt-get clean

# Install Java
RUN apt-get update && \
    apt-get -y install openjdk-11-jdk && \
    apt-get clean

# Set environment variables
ENV JAVA_HOME /usr/lib/jvm/java-1.11.0-openjdk-amd64
ENV CATALINA_HOME /opt/tomcat
ENV CATALINA_BASE /opt/tomcat
ENV CATALINA_PID /opt/tomcat/temp/tomcat.pid
ENV CATALINA_OPTS -Xms512M -Xmx1024M -server -XX:+UseParallelGC
ENV JAVA_OPTS -Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom

# Download and extract Tomcat
RUN wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.5/bin/apache-tomcat-9.0.5.tar.gz && \
    tar -xzvf apache-tomcat-9.0.5.tar.gz && \
    rm apache-tomcat-9.0.5.tar.gz && \
    mv apache-tomcat-9.0.5 /opt/tomcat && \
    chmod +x /opt/tomcat/bin/*.sh

# Copy tomcat-users.xml to add user
COPY tomcat-users.xml /opt/tomcat/conf/
COPY context.xml /opt/tomcat/webapps/manager/META-INF
COPY OscarMovieProject-0.0.1-SNAPSHOT.war /opt/tomcat/webapps/
# Expose the default Tomcat port
EXPOSE 8080

# Set the working directory
WORKDIR /opt/tomcat

# Start Tomcat
CMD ["/bin/bash", "-c", "/opt/tomcat/bin/startup.sh && tail -f /opt/tomcat/logs/catalina.out"]

