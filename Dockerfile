FROM maven:3.8.4-openjdk-17 AS build
WORKDIR /app
COPY . .
RUN mvn clean install

FROM adoptopenjdk:17-jre-hotspot
WORKDIR /app
COPY --from=build /app/target/demoapp.jar /app/
EXPOSE 8080
CMD [ "java", "-jar", "demoapp.jar" ]

