FROM openjdk:8u131-jre

MAINTAINER Gopala Krishnan

ADD target/positiontracker-0.0.1-SNAPSHOT.jar positiontracker.jar

EXPOSE 8080

CMD ["java","-Xmx50m","-jar","positiontracker.jar"]
