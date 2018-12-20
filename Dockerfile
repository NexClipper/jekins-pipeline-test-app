FROM openjdk:8-jdk-alpine
LABEL maintainer="Nelson Kim"
VOLUME /tmp
ADD ./build/libs/app.jar app.jar
EXPOSE 9000
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","./app.jar"]