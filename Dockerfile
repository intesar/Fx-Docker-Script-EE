FROM openjdk:8-jre

VOLUME /tmp

ADD Web.jar control-plane.jar

RUN bash -c 'touch /control-plane.jar'

EXPOSE 8080

ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/control-plane.jar"]
