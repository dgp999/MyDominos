FROM tomcat:8.0.20-jre8
# Dummy text to test 
COPY target/mywebapp.war /usr/local/tomcat/webapps/mywebapp.war

#FROM ubuntu:latest
#RUN apt-get update -y
#RUN apt-get install git -y
#RUN apt-get install apache2 -y
