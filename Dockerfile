FROM tomcat:jre8-openjdk-slim-buster
COPY target/*.war /usr/local/tomcat/webapps
